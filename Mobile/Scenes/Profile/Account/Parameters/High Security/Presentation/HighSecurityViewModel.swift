//
//  HighSecurityViewModel.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 6/25/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

protocol HighSecurityViewModel: BaseViewModel,
                                HighSecurityViewModelInput,
                                HighSecurityViewModelOutput { }

protocol HighSecurityViewModelInput: AnyObject {
    func viewDidLoad()
    func buttonTapped()
}

protocol HighSecurityViewModelOutput {
    var action: Observable<HighSecurityViewModelOutputAction> { get }
    var route: Observable<HighSecurityViewModelRoute> { get }
}

enum HighSecurityViewModelOutputAction {
    case setButtonState(isOn: Bool)
    case close
    case isLoading(loading: Bool)
    case showSuccess
}

enum HighSecurityViewModelRoute {
    case otp(params: OTPViewModelParams)
}

class DefaultHighSecurityViewModel: DefaultBaseViewModel {
    private let actionSubject = PublishSubject<HighSecurityViewModelOutputAction>()
    private let routeSubject = PublishSubject<HighSecurityViewModelRoute>()

    @Inject(from: .useCases) private var useCase: HighSecurityUseCase

    // state
    var isEnabled = false
}

extension DefaultHighSecurityViewModel: HighSecurityViewModel {
    var action: Observable<HighSecurityViewModelOutputAction> { actionSubject.asObserver() }
    var route: Observable<HighSecurityViewModelRoute> { routeSubject.asObserver() }

    func viewDidLoad() {
        notify(.isLoading(loading: true))
        useCase.isEnabled(handler(onSuccessHandler: { isEnabled in
            self.isEnabled = isEnabled // update state
            self.notify(.setButtonState(isOn: isEnabled))
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                self?.notify(.isLoading(loading: false))
            }
        }))
    }

    func buttonTapped() {
        openOTP()
    }

    private func openOTP(_ username: String = "") {
        let otpParams: OTPViewModelParams = .init(vcTitle: R.string.localization.sms_login_page_title.localized(), buttonTitle: R.string.localization.sms_approve.localized(), username: username, otpType: .actionOTP)
        subscribeTo(otpParams)
        routeSubject.onNext(.otp(params: otpParams))
    }

    private func subscribeTo(_ params: OTPViewModelParams) {
        params.paramsOutputAction.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)
    }

    private func didRecive(action: OTPViewModelParams.Action) {
        switch action {
        case .success(let code, _):
            handleSuccessOTP(with: code ?? "")
        case .error:
            show(error: .init()) // TODO: show appropriate error
        }
    }

    private func handleSuccessOTP(with code: String) {
        notify(.isLoading(loading: true))
        useCase.set(isEnabled: !isEnabled, otp: code, handler(onSuccessHandler: { _ in
            self.isEnabled.toggle() // update state
            self.notify(.setButtonState(isOn: self.isEnabled))
            self.actionSubject.onNext(.showSuccess)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                self?.notify(.isLoading(loading: false))
            }
        }))
    }

    private func notify(_ action: HighSecurityViewModelOutputAction) {
        actionSubject.onNext(action)
    }
}
