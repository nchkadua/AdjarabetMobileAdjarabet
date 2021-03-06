//
//  PasswordChangeViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 11/25/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

protocol PasswordChangeViewModel: BaseViewModel, PasswordChangeViewModelInput, PasswordChangeViewModelOutput {
}

public protocol PasswordChangeViewModelInput {
    func viewDidLoad()
    func newPasswordDidChange(to newPassword: String)
    func changeDidTap(_ oldPassword: String, newPassword: String)
}

public protocol PasswordChangeViewModelOutput {
    var action: Observable<PasswordChangeViewModelOutputAction> { get }
    var route: Observable<PasswordChangeViewModelRoute> { get }
}

public enum PasswordChangeViewModelOutputAction {
    case updateRulesWithNewPassword(_ password: String)
    case setButton(loading: Bool)
}

public enum PasswordChangeViewModelRoute {
    case openOTP(params: OTPViewModelParams)
}

public class DefaultPasswordChangeViewModel: DefaultBaseViewModel {
    @Inject(from: .repositories) private var repo: IsOTPEnabledRepository
    @Inject(from: .useCases) private var passwordChangeUseCase: PasswordChangeUseCase
    private let actionSubject = PublishSubject<PasswordChangeViewModelOutputAction>()
    private let routeSubject = PublishSubject<PasswordChangeViewModelRoute>()
    //
    private var oldPassword: String?
    private var newPassword: String?
}

extension DefaultPasswordChangeViewModel: PasswordChangeViewModel {
    public var action: Observable<PasswordChangeViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<PasswordChangeViewModelRoute> { routeSubject.asObserver() }

    public func viewDidLoad() {
    }

    public func changeDidTap(_ oldPassword: String, newPassword: String) {
        repo.isEnabled(handler(onSuccessHandler: { enabled in
            switch enabled {
            case true:
                self.oldPassword = oldPassword
                self.newPassword = newPassword
                self.getActionOtp()
            case false:
                self.changePassword(oldPassword, newPassword: newPassword, otp: -1)
            }
        }))
    }

    public func newPasswordDidChange(to newPassword: String) {
        actionSubject.onNext(.updateRulesWithNewPassword(newPassword))
    }

    private func getActionOtp() {
        self.openOTP("")
    }

    private func openOTP(_ username: String) {
        let otpParams: OTPViewModelParams = .init(vcTitle: R.string.localization.sms_login_page_title.localized(), buttonTitle: R.string.localization.sms_approve.localized(), username: username, otpType: .actionOTP)
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
        case .success(let code, _): handleSuccessfulOTP(code ?? "")
        case .error: self.show(error: .init()) // TODO: show appropriate error
        }
    }

    private func handleSuccessfulOTP(_ otp: String) {
        changePassword(self.oldPassword ?? "", newPassword: self.newPassword ?? "", otp: Int(otp) ?? -1)
    }

    public func changePassword(_ oldPassword: String, newPassword: String, otp: Int) {
        self.actionSubject.onNext(.setButton(loading: true))
        passwordChangeUseCase.change(oldPassword: oldPassword, newPassword: newPassword, otp: otp) { result in
            defer { self.actionSubject.onNext(.setButton(loading: false)) }
            switch result {
            case .success:
                // TODO: add correct icon
                self.show(error: .init(type: .`init`(description: .popup(description: .init(icon: .init(), description: "Password Changed Succesfully")))))
            case .failure(let error):
                self.show(error: error)
            }
        }
    }
}
