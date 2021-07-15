//
//  PasswordResetViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 30.06.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public protocol PasswordResetViewModel: PasswordResetViewModelInput, PasswordResetViewModelOutput {
}

public struct PasswordResetViewModelParams {
    let resetType: PasswordResetType
    let contact: String
    let showDismissButton: Bool
}

public protocol PasswordResetViewModelInput: AnyObject {
    var params: PasswordResetViewModelParams { get set }
    func viewDidLoad()
    func newPasswordDidChange(to newPassword: String)
    func changeDidTap(_ phoneNumber: String, _ newPassword: String)
}

public protocol PasswordResetViewModelOutput {
    var action: Observable<PasswordResetViewModelOutputAction> { get }
    var route: Observable<PasswordResetViewModelRoute> { get }
}

public enum PasswordResetViewModelOutputAction {
    case updateRulesWithNewPassword(_ password: String)
    case setupPhoneNumber(_ number: String)
    case setButton(loading: Bool)
    case setupWith(_ resetType: PasswordResetType, _ contact: String)
    case showMessage(message: String)
}

public enum PasswordResetViewModelRoute {
    case openOTP(params: OTPViewModelParams)
}

public class DefaultPasswordResetViewModel: DefaultBaseViewModel {
    public var params: PasswordResetViewModelParams
    private let actionSubject = PublishSubject<PasswordResetViewModelOutputAction>()
    private let routeSubject = PublishSubject<PasswordResetViewModelRoute>()
    @Inject(from: .useCases) private var resetPasswordUseCase: ResetPasswordUseCase

    //
    private var newPassword: String?

    public init(params: PasswordResetViewModelParams) {
        self.params = params
    }
}

extension DefaultPasswordResetViewModel: PasswordResetViewModel {
    public var action: Observable<PasswordResetViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<PasswordResetViewModelRoute> { routeSubject.asObserver() }

    public func viewDidLoad() {
        actionSubject.onNext(.setupWith(params.resetType, params.contact))
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
