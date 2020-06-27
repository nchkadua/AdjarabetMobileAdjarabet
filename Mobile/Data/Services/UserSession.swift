//
//  UserSession.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/12/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public class UserSession: UserSessionServices {
    private let disposeBag = DisposeBag()
    private let actionSubject = PublishSubject<UserSessionAction>()
    private let isLogedInSubject = PublishSubject<Bool>()
    private let careTaker: UserSessionCareTaker

    public static let current = UserSession()

    private init(careTaker: UserSessionCareTaker = UserSessionCareTaker()) {
        self.careTaker = careTaker
        let memento = try? careTaker.load()

        self.isLogedInSubject.subscribe(onNext: { [weak self] _ in
            guard let self = self else {return}
            self.actionSubject.onNext(.authentication(isLoggedIn: self.isLoggedIn))
        })
        .disposed(by: disposeBag)

        if memento == nil {
            try? careTaker.save(UserSession.Memento())
        }
    }

    public struct Memento: Codable {
        public var isLoggedIn: Bool = false
        public var sessionId: String?
        public var username: String?
        public var password: String?
        public var userId: Int?
        public var currencyId: Int?
    }
}

extension UserSession: UserSessionReadableServices {
    public var action: Observable<UserSessionAction> { actionSubject.asObserver() }

    private var memento: UserSession.Memento? { try? careTaker.load() }

    public var isLoggedIn: Bool { memento?.isLoggedIn ?? false }

    public var userId: Int? { memento?.userId }

    public var username: String? { memento?.username }

    public var password: String? { memento?.password }

    public var sessionId: String? { memento?.sessionId }

    public var currencyId: Int? { memento?.currencyId }
}

extension UserSession: UserSessionWritableServices {
    public func login() {
        set(isLoggedIn: true)
    }

    public func logout() {
        set(isLoggedIn: false)
    }

    public func set(isLoggedIn: Bool) {
        do {
            var memento = try careTaker.load()
            memento.isLoggedIn = isLoggedIn
            try careTaker.save(memento)
            actionSubject.onNext(.authentication(isLoggedIn: isLoggedIn))
        } catch {
            print(error.localizedDescription)
        }
    }

    public func set(userId: Int, username: String, sessionId: String, currencyId: Int?, password: String?) {
        do {
            var memento = try careTaker.load()
            let oldUserId = memento.userId

            memento.userId = userId
            memento.username = username
            memento.sessionId = sessionId
            memento.currencyId = currencyId

            // If password is nil and user is different reset the password
            // if password is provided just save
            if (password == nil && oldUserId != userId) || password != nil {
                memento.password = password
            }

            try careTaker.save(memento)
            actionSubject.onNext(.fields)
        } catch {
            print(error.localizedDescription)
        }
    }

    public func remove() {
        do {
            logout()
            try careTaker.save(nil)
            try careTaker.save(UserSession.Memento())
            actionSubject.onNext(.removed)
        } catch {
            print(error.localizedDescription)
        }
    }
}
