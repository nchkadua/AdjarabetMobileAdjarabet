//
//  UserBalanceService.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 5/17/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public protocol UserBalanceService: UserBalanceServiceReadableService, UserBalanceServiceWritableService {
}

public protocol UserBalanceServiceReadableService {
    var balance: Double? { get }
    var balanceObservable: Observable<Double?> { get }
}

public protocol UserBalanceServiceWritableService {
    func update()
}

public class DefaultUserBalanceService {
    @Inject(from: .repositories) private var balanceManagementRepository: BalanceManagementRepository
    @Inject private var userSession: UserSessionServices

    private let balanceSubject = PublishSubject<Double?>()
    private let disposeBag = DisposeBag()

    public static let shared = DefaultUserBalanceService()

    public var balance: Double? {
        didSet {
            if balance == oldValue {return}
            balanceSubject.onNext(balance)
        }
    }

    private init() {
        bindAuthenticationStateChanges()
        update()
    }

    private func bindAuthenticationStateChanges() {
        userSession.action
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] action in
                switch action {
                case .authentication(let isLoggedIn):
                    self?.configureWhen(isLoggedIn: isLoggedIn)
                default: break
                }
            }).disposed(by: disposeBag)
    }

    private func configureWhen(isLoggedIn: Bool) {
        if isLoggedIn {
            update()
        } else {
            self.balance = nil
        }
    }
}

extension DefaultUserBalanceService: UserBalanceService {
    public var balanceObservable: Observable<Double?> { balanceSubject.asObserver() }

    public func update() {
        guard let userId = userSession.userId, let sessionId = userSession.sessionId else {return}

        balanceManagementRepository.balance(userId: userId,
                                            currencyId: userSession.currencyId ?? -1,
                                            isSingle: 0,
                                            sessionId: sessionId) { [weak self] (result: Result<AdjarabetCoreResult.Balance, ABError>) in
                switch result {
                case .success(let value):
                    self?.balance = value.codable.balanceAmount / 100
                case .failure(let error):
                    self?.balance = nil
                    print(error.localizedDescription)
                }
        }
    }
}
