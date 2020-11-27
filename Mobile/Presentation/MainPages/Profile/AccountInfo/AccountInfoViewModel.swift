//
//  AccountInfoViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/21/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public protocol AccountInfoViewModel: AccountInfoViewModelInput, AccountInfoViewModelOutput {
}

public protocol AccountInfoViewModelInput {
    func viewDidLoad()
}

public protocol AccountInfoViewModelOutput {
    var action: Observable<AccountInfoViewModelOutputAction> { get }
    var route: Observable<AccountInfoViewModelRoute> { get }
}

public enum AccountInfoViewModelOutputAction {
    case setupWithUserInfo(_ userInfo: UserInfoServices)
    case setupWithUserSession(_ userSessionModel: UserSessionModel)
}

public enum AccountInfoViewModelRoute {
}

public class DefaultAccountInfoViewModel {
    private let actionSubject = PublishSubject<AccountInfoViewModelOutputAction>()
    private let routeSubject = PublishSubject<AccountInfoViewModelRoute>()

    @Inject(from: .repositories) private var userInfoRepo: UserInfoReadableRepository
    @Inject private var userSession: UserSessionServices
    //Temporary
    public let userInfo = UserInfoServices()
}

extension DefaultAccountInfoViewModel: AccountInfoViewModel {
    public var action: Observable<AccountInfoViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<AccountInfoViewModelRoute> { routeSubject.asObserver() }

    public func viewDidLoad() {
        refreshUserInfo()
        actionSubject.onNext(.setupWithUserInfo(userInfo))

        let userSessionModel = UserSessionModel(username: userSession.username ?? "Guest", userId: String(userSession.userId ?? 0), password: String.passwordRepresentation)
        actionSubject.onNext(.setupWithUserSession(userSessionModel))
    }

    private func refreshUserInfo() {
        userInfoRepo.currentUserInfo(params: .init()) { result in
            print(result)
        }
    }
}
