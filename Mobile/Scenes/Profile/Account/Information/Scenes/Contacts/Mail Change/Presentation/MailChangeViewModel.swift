//
//  MailChangeViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 11/24/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public protocol MailChangeViewModel: MailChangeViewModelInput, MailChangeViewModelOutput {
}

public protocol MailChangeViewModelInput {
    func viewDidLoad()
    func updateMail(_ newMail: String, _ password: String)
}

public protocol MailChangeViewModelOutput {
    var action: Observable<MailChangeViewModelOutputAction> { get }
    var route: Observable<MailChangeViewModelRoute> { get }
}

public enum MailChangeViewModelOutputAction {
    case setButton(loading: Bool)
    case showMessage(message: String)
}

public enum MailChangeViewModelRoute {
    case openOTP(params: OTPViewModelParams)
}

public class DefaultMailChangeViewModel: DefaultBaseViewModel {
    @Inject(from: .repositories) private var actionOTPRepo: IsOTPEnabledRepository
    @Inject(from: .useCases) private var updateMailUseCase: UpdateMailUseCase
    private let actionSubject = PublishSubject<MailChangeViewModelOutputAction>()
    private let routeSubject = PublishSubject<MailChangeViewModelRoute>()
    //
    private var newMail: String?
    private var password: String?
}

extension DefaultMailChangeViewModel: MailChangeViewModel {
    public var action: Observable<MailChangeViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<MailChangeViewModelRoute> { routeSubject.asObserver() }

    public func viewDidLoad() {
    }

    public func updateMail(_ newMail: String, _ password: String) {
        actionOTPRepo.isEnabled { result in
            switch result {
            case .success(let enabled):
                switch  enabled {
                case true:
                    self.newMail = newMail
                    self.password = password
                    self.getActionOtp()
                case false:
                    self.changeMail(newMail, password, otp: "")
                }
            case .failure(let error):
                self.actionSubject.onNext(.showMessage(message: error.localizedDescription))
            }
        }
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
        case .success(let code): handleSuccessfulOTP(code)
        case .error: self.actionSubject.onNext(.showMessage(message: "Invalid OTP"))
        }
    }

    private func handleSuccessfulOTP(_ otp: String) {
        changeMail(self.newMail ?? "", self.password ?? "", otp: otp)
    }

    private func changeMail(_ newMail: String, _ password: String, otp: String) {
        self.actionSubject.onNext(.setButton(loading: true))
        updateMailUseCase.execute(with: .init(pass: password, email: newMail, otp: otp)) { result in
            defer { self.actionSubject.onNext(.setButton(loading: false)) }
            switch result {
            case .success: self.actionSubject.onNext(.showMessage(message: "Mail Changed Successfully"))
            case .failure(let error): self.actionSubject.onNext(.showMessage(message: error.localizedDescription))
            }
        }
    }
}
