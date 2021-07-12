//
//  NewPasswordViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 30.06.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public protocol NewPasswordViewModel: NewPasswordViewModelInput, NewPasswordViewModelOutput {
}

public struct NewPasswordViewModelParams {
}

public protocol NewPasswordViewModelInput: AnyObject {
    var params: NewPasswordViewModelParams { get set }
    func viewDidLoad()
    func newPasswordDidChange(to newPassword: String)
    func changeDidTap(_ phoneNumber: String, _ newPassword: String)
}

public protocol NewPasswordViewModelOutput {
    var action: Observable<NewPasswordViewModelOutputAction> { get }
    var route: Observable<NewPasswordViewModelRoute> { get }
}

public enum NewPasswordViewModelOutputAction {
    case updateRulesWithNewPassword(_ password: String)
    case setupPhoneNumber(_ number: String)
    case setButton(loading: Bool)
    case showMessage(message: String)
}

public enum NewPasswordViewModelRoute {
    case openOTP(params: OTPViewModelParams)
}

public class DefaultNewPasswordViewModel: DefaultBaseViewModel {
    public var params: NewPasswordViewModelParams
    private let actionSubject = PublishSubject<NewPasswordViewModelOutputAction>()
    private let routeSubject = PublishSubject<NewPasswordViewModelRoute>()
    @Inject(from: .useCases) private var resetPasswordUseCase: ResetPasswordUseCase

    //
    private var newPassword: String?

    public init(params: NewPasswordViewModelParams) {
        self.params = params
    }
}

extension DefaultNewPasswordViewModel: NewPasswordViewModel {
    public var action: Observable<NewPasswordViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<NewPasswordViewModelRoute> { routeSubject.asObserver() }

    public func viewDidLoad() {
        resetPasswordUseCase.initPasswordReset { result in
            switch result {
            case .success(let entity):
                let subString = entity.tel?.dropLast(4)
                self.actionSubject.onNext(.setupPhoneNumber(String(subString ?? "No phone number")))
            case .failure(let error):
                self.actionSubject.onNext(.showMessage(message: error.localizedDescription))
            }
        }
    }

    public func newPasswordDidChange(to newPassword: String) {
        actionSubject.onNext(.updateRulesWithNewPassword(newPassword))
    }

    public func changeDidTap(_ phoneNumber: String, _ newPassword: String) {
        self.newPassword = newPassword
        let otpParams: OTPViewModelParams = .init(vcTitle: R.string.localization.title_verification.localized(), buttonTitle: R.string.localization.sms_approve.localized(), otpType: .passwordResetCode(phoneNumber: phoneNumber))
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
        self.actionSubject.onNext(.setButton(loading: true))
        resetPasswordUseCase.resetPassword(params: .init(confirmCode: otp, newPassword: self.newPassword ?? "")) { result in
            defer { self.actionSubject.onNext(.setButton(loading: false)) }
            switch result {
            case .success: self.actionSubject.onNext(.showMessage(message: "Password Reseted Succesfully"))
            case .failure(let error): self.actionSubject.onNext(.showMessage(message: error.localizedDescription))
            }
        }
    }
}
