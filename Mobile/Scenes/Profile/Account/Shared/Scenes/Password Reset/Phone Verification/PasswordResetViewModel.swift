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
}

public protocol PasswordResetViewModelInput: AnyObject {
    var params: PasswordResetViewModelParams { get set }
    func viewDidLoad()
    func actionDidTap(_ phoneNumber: String)
}

public protocol PasswordResetViewModelOutput {
    var action: Observable<PasswordResetViewModelOutputAction> { get }
    var route: Observable<PasswordResetViewModelRoute> { get }
}

public enum PasswordResetViewModelOutputAction {
    case setupPhoneNumber(_ number: String)
    case showMessage(message: String)
}

public enum PasswordResetViewModelRoute {
    case openOTP(params: OTPViewModelParams)
    case navigateToNewPassword
}

public class DefaultPasswordResetViewModel: DefaultBaseViewModel {
    public var params: PasswordResetViewModelParams
    private let actionSubject = PublishSubject<PasswordResetViewModelOutputAction>()
    private let routeSubject = PublishSubject<PasswordResetViewModelRoute>()
    @Inject(from: .useCases) private var resetPasswordUseCase: ResetPasswordUseCase

    public init(params: PasswordResetViewModelParams) {
        self.params = params
    }
}

extension DefaultPasswordResetViewModel: PasswordResetViewModel {
    public var action: Observable<PasswordResetViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<PasswordResetViewModelRoute> { routeSubject.asObserver() }

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

    public func actionDidTap(_ phoneNumber: String) {
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { //Navigation to be visible
            self.routeSubject.onNext(.navigateToNewPassword)
        }
    }
}
