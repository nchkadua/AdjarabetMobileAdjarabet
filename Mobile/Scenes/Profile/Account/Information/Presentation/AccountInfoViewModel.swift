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
    case setupWithAccountInfoModel(_ accountInfoModel: AccountInfoModel)
}

public enum AccountInfoViewModelRoute {
}

public class DefaultAccountInfoViewModel {
    private let actionSubject = PublishSubject<AccountInfoViewModelOutputAction>()
    private let routeSubject = PublishSubject<AccountInfoViewModelRoute>()

    @Inject(from: .repositories) private var userInfoRepo: UserInfoReadableRepository
    @Inject(from: .repositories) private var langRepo: CommunicationLanguageRepository
}

extension DefaultAccountInfoViewModel: AccountInfoViewModel {
    public var action: Observable<AccountInfoViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<AccountInfoViewModelRoute> { routeSubject.asObserver() }

    public func viewDidLoad() {
        refreshUserInfo()
    }

    private func refreshUserInfo() {
        userInfoRepo.currentUserInfo(params: .init()) { [weak self] result in
            switch result {
            case .success(let userInfo):
                let accountInfoModel = AccountInfoModel.create(from: userInfo)
                self?.actionSubject.onNext(.setupWithAccountInfoModel(accountInfoModel))
            case .failure(let error):
                print(error) // FIXME error handling
            }
        }
        /*
        // getUserLang
        langRepo.getUserLang { result in
            switch result {
            case .success(let language):
                print("UserLang.getUserLang.Success:", language)
            case .failure(let error):
                print("UserLang.getUserLang.Failure:", error)
            }
        }
        // changeUserLang
        langRepo.changeUserLang(with: .english) { result in
            switch result {
            case .success:
                print("UserLang.changeUserLang.Success")
            case .failure(let error):
                print("UserLang.changeUserLang.Failure:", error)
            }
        }
        */
    }
}