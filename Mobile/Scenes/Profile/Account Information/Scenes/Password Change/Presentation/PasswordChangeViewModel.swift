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
    func changePassword(_ oldPassword: String, newPassword: String)
}

public protocol PasswordChangeViewModelOutput {
    var action: Observable<PasswordChangeViewModelOutputAction> { get }
    var route: Observable<PasswordChangeViewModelRoute> { get }
}

public enum PasswordChangeViewModelOutputAction {
    case updateRulesWithNewPassword(_ password: String)
    case setButton(loading: Bool)
    case showMessage(message: String)
}

public enum PasswordChangeViewModelRoute {
    case openOTP(params: OTPViewModelParams)
}

public class DefaultPasswordChangeViewModel: DefaultBaseViewModel {
    @Inject(from: .repositories) private var repo: IsOTPEnabledRepository
    @Inject(from: .repositories) private var actionTOPRepo: ActionOTPRepository
    @Inject(from: .useCases) private var passwordChangeUseCase: PasswordChangeUseCase
    private let actionSubject = PublishSubject<PasswordChangeViewModelOutputAction>()
    private let routeSubject = PublishSubject<PasswordChangeViewModelRoute>()
}

extension DefaultPasswordChangeViewModel: PasswordChangeViewModel {
    public var action: Observable<PasswordChangeViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<PasswordChangeViewModelRoute> { routeSubject.asObserver() }

    public func viewDidLoad() {
        //Move to different place
        /* repo.isEnabled { result in
            switch result {
            case .success:
                self.getActionOtp()
            case .failure(let error):
                self.actionSubject.onNext(.showMessage(message: error.localizedDescription))
            }
        } */
    }

    public func changePassword(_ oldPassword: String, newPassword: String) {
        self.actionSubject.onNext(.setButton(loading: true))
        passwordChangeUseCase.change(oldPassword: oldPassword, newPassword: newPassword) { result in
            defer { self.actionSubject.onNext(.setButton(loading: false)) }
            switch result {
            case .success: self.actionSubject.onNext(.showMessage(message: "Password Changed Successfully"))
            case .failure(let error): self.actionSubject.onNext(.showMessage(message: error.localizedDescription))
            }
        }
    }

    public func newPasswordDidChange(to newPassword: String) {
        actionSubject.onNext(.updateRulesWithNewPassword(newPassword))
    }

    private func getActionOtp() {
        actionTOPRepo.actionOTP { result in
            switch result {
            case .success: self.openOTP("")
            case .failure(let error): self.actionSubject.onNext(.showMessage(message: error.localizedDescription))
            }
        }
    }

    private func openOTP(_ username: String) {
        let otpParams: OTPViewModelParams = .init(vcTitle: R.string.localization.sms_login_page_title.localized(), buttonTitle: R.string.localization.sms_approve.localized(), username: username, getOtp: false)
        routeSubject.onNext(.openOTP(params: otpParams))
        subscribeTo(otpParams)
    }

    private func subscribeTo(_ params: OTPViewModelParams) {
        params.paramsOutputAction.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)
    }

    private func didRecive(action: OTPViewModelParams.Action) {
        switch action {
        case .success(let code): handleSuccessfulOTP(code)
        case .error: self.actionSubject.onNext(.showMessage(message: "Invalid OTP"))
        }
    }

    private func handleSuccessfulOTP(_ otp: String) {
        print("asdasdasdasds ", otp)
    }
}
