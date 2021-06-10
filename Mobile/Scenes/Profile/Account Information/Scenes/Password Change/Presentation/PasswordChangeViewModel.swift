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
    case showMessage(message: String)
}

public enum PasswordChangeViewModelRoute {
}

public class DefaultPasswordChangeViewModel {
    @Inject(from: .repositories) private var repo: IsOTPEnabledRepository
    @Inject(from: .repositories) private var actionTOPRepo: ActionOTPRepository
    private let actionSubject = PublishSubject<PasswordChangeViewModelOutputAction>()
    private let routeSubject = PublishSubject<PasswordChangeViewModelRoute>()
}

extension DefaultPasswordChangeViewModel: PasswordChangeViewModel {
    public var action: Observable<PasswordChangeViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<PasswordChangeViewModelRoute> { routeSubject.asObserver() }

    public func viewDidLoad() {
        repo.isEnabled { result in
            switch result {
            case .success:
                self.getActionOtp()
            case .failure(let error):
                self.actionSubject.onNext(.showMessage(message: error.localizedDescription))
            }
        }
    }

    private func getActionOtp() {
        actionTOPRepo.actionOTP { result in
            switch result {
            case .success: print("success")
            case .failure(let error): self.actionSubject.onNext(.showMessage(message: error.localizedDescription))
            }
        }
    }

    public func newPasswordDidChange(to newPassword: String) {
        actionSubject.onNext(.updateRulesWithNewPassword(newPassword))
    }
}
