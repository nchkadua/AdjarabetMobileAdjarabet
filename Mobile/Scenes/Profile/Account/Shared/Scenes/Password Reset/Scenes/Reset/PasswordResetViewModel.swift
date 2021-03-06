//
//  PasswordResetViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 30.06.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

protocol PasswordResetViewModel: BaseViewModel, PasswordResetViewModelInput, PasswordResetViewModelOutput {
}

public struct PasswordResetViewModelParams {
    let username: String?
    let resetType: PasswordResetType
    let contact: String
    let showDismissButton: Bool
}

public protocol PasswordResetViewModelInput: AnyObject {
    var params: PasswordResetViewModelParams { get set }
    func viewDidLoad()
    func newPasswordDidChange(to newPassword: String)
    func changeDidTap(_ contact: String, _ newPassword: String)
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

    public func changeDidTap(_ contact: String, _ newPassword: String) {
        self.newPassword = newPassword
        let deliveryChannel = OTPDeliveryChannel(rawValue: params.resetType.rawValue) ?? .sms
        let otpParams: OTPViewModelParams = .init(vcTitle: R.string.localization.title_verification.localized(), buttonTitle: R.string.localization.sms_approve.localized(), otpType: .passwordResetCode(username: params.username, channelType: deliveryChannel, contact: contact))
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
        case .success(let code, let userId): handleSuccessfulOTP(code, userId)
        case .error: show(error: .init()) // TODO: show appropriate error
        }
    }

    private func handleSuccessfulOTP(_ otp: String?, _ userId: String?) {
        self.actionSubject.onNext(.setButton(loading: true))
        resetPasswordUseCase.resetPassword(params: .init(confirmCode: otp, newPassword: self.newPassword ?? "", userId: userId)) { result in
            defer { self.actionSubject.onNext(.setButton(loading: false)) }
            switch result {
            case .success:
                // TODO: add correct icon
                self.show(error: .init(type: .`init`(description: .popup(description: .init(icon: .init(), description: "Password Reseted Succesfully")))))
            case .failure(let error):
                self.show(error: error)
            }
        }
    }
}
