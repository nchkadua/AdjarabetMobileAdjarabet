//
//  PasswordChangeViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 11/25/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public protocol PasswordChangeViewModel: PasswordChangeViewModelInput, PasswordChangeViewModelOutput {
}

public protocol PasswordChangeViewModelInput {
    func viewDidLoad()
    func newPasswordDidChange(to newPassword: String)
}

public protocol PasswordChangeViewModelOutput {
    var action: Observable<PasswordChangeViewModelOutputAction> { get }
    var route: Observable<PasswordChangeViewModelRoute> { get }
}

public enum PasswordChangeViewModelOutputAction {
    case updateRulesWithNewPassword(_ password: String)
}

public enum PasswordChangeViewModelRoute {
}

public class DefaultPasswordChangeViewModel {
    @Inject(from: .repositories) private var repo: IsOTPEnabledRepository
    private let actionSubject = PublishSubject<PasswordChangeViewModelOutputAction>()
    private let routeSubject = PublishSubject<PasswordChangeViewModelRoute>()
}

extension DefaultPasswordChangeViewModel: PasswordChangeViewModel {
    public var action: Observable<PasswordChangeViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<PasswordChangeViewModelRoute> { routeSubject.asObserver() }

    public func viewDidLoad() {
        repo.isEnabled { result in
            switch result {
            case .success(let isEnabled):
                print("IsOTPEnabledRepository.Success:", isEnabled)
            case .failure(let error):
                print("IsOTPEnabledRepository.Failure:", error)
            }
        }
    }

    public func newPasswordDidChange(to newPassword: String) {
        actionSubject.onNext(.updateRulesWithNewPassword(newPassword))
    }
}
