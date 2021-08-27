//
//  LoginViewModel.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 5/11/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

protocol LoginViewModel: BaseViewModel, LoginViewModelInput, LoginViewModelOutput {
}

struct LoginViewModelParams {
    var showBiometryLoginAutomatically: Bool

    public init (showBiometryLoginAutomatically: Bool) {
        self.showBiometryLoginAutomatically = showBiometryLoginAutomatically
    }
}

protocol LoginViewModelInput {
    func viewDidLoad()
    func smsLogin(username: String)
    func login(username: String, password: String)
    func biometricLogin()
    func languageDidChange()
}

protocol LoginViewModelOutput {
    var action: Observable<LoginViewModelOutputAction> { get }
    var route: Observable<LoginViewModelRoute> { get }
    var params: LoginViewModelParams { get }
}

enum LoginViewModelOutputAction {
    case setLoginButton(isLoading: Bool)
    case setSmsLoginButton(isLoading: Bool)
    case setBiometryButton(isLoading: Bool)
    case configureBiometryButton(available: Bool, icon: UIImage?, title: String?)
    case configureQaButton(image: UIImage)
}

enum LoginViewModelRoute {
    case openOTP(params: OTPViewModelParams)
    case openMainTabBar(params: MainContainerViewModelParams)
    case openAlert(title: String, message: String? = nil)
}

class DefaultLoginViewModel: DefaultBaseViewModel {
    private let actionSubject = PublishSubject<LoginViewModelOutputAction>()
    private let routeSubject = PublishSubject<LoginViewModelRoute>()
    let params: LoginViewModelParams

    @Inject(from: .useCases) private var loginUseCase: LoginUseCase
    @Inject(from: .useCases) private var smsCodeUseCase: SMSCodeUseCase
    @Inject(from: .useCases) private var biometricLoginUseCase: BiometricLoginUseCase
    @Inject private var biometryStateStorage: BiometryReadableStorage

    init(params: LoginViewModelParams = LoginViewModelParams(showBiometryLoginAutomatically: true)) {
        self.params = params
    }

    private func handleLogin(result: Result<LoginUseCaseSuccess, ABError>) {
        defer { actionSubject.onNext(.setLoginButton(isLoading: false)) }
        switch result {
        case .success(let type):
            switch type {
            case .success(let params):
                routeSubject.onNext(.openMainTabBar(params: params))
            case .otpRequried(let username): openOTP(username, otpType: .loginOTP)
            }
        case .failure(_): break
        }
    }

    private func openOTP(_ username: String, otpType: OTPType) {
        let otpParams: OTPViewModelParams = .init(vcTitle: R.string.localization.sms_login_page_title.localized(), buttonTitle: R.string.localization.sms_approve.localized(), username: username, otpType: otpType)
        routeSubject.onNext(.openOTP(params: otpParams))
    }

    override func languageDidChange() {
        actionSubject.onNext(.configureBiometryButton(available: biometricLoginUseCase.isAvailable && biometryIsOn,
                                                      icon: biometricLoginUseCase.icon,
                                                      title: biometricLoginUseCase.title))
        getQAImageByLanguage()
    }

    override func errorActionHandler(buttonType: ABError.Description.Popup.ButtonType, error: ABError) {
        if case .ipIsBlocked = error.type,
           case .call = buttonType {
            guard let number = URL(string: "tel://+995322711010") else { return }
            UIApplication.shared.open(number, options: [:], completionHandler: nil)
        }
    }
}

extension DefaultLoginViewModel: LoginViewModel {
    var action: Observable<LoginViewModelOutputAction> { actionSubject.asObserver() }
    var route: Observable<LoginViewModelRoute> { routeSubject.asObserver() }

    private var biometryIsOn: Bool {
        biometryStateStorage.currentState == .on
    }

    func viewDidLoad() {
        actionSubject.onNext(.configureBiometryButton(available: biometricLoginUseCase.isAvailable && biometryIsOn,
                                                      icon: biometricLoginUseCase.icon,
                                                      title: biometricLoginUseCase.title))
        getQAImageByLanguage()

        if params.showBiometryLoginAutomatically && biometryIsOn {
            biometricLogin()
        }
    }

    private func getQAImageByLanguage() {
        var image: UIImage?
        switch languageStorage.currentLanguage {
        case .georgian: image = R.image.login.qa_geo()
        case .english: image = R.image.login.qa_eng()
        case .armenian: image = R.image.login.qa_eng()
        }

        actionSubject.onNext(.configureQaButton(image: image ?? UIImage()))
    }

    func smsLogin(username: String) {
        actionSubject.onNext(.setSmsLoginButton(isLoading: true))
        smsCodeUseCase.execute(username: username) { [weak self] result in
            defer { self?.actionSubject.onNext(.setSmsLoginButton(isLoading: false)) }
            switch result {
            case .success: self?.openOTP(username, otpType: .smsLogin)
            case .failure(let error): self?.show(error: error)
            }
        }
    }

    func login(username: String, password: String) {
        actionSubject.onNext(.setLoginButton(isLoading: true))
        loginUseCase.execute(username: username, password: password, completion: handleLogin(result:))
    }

    func biometricLogin() {
        biometricLoginUseCase.execute(biometricSuccess: { [weak self] in
            self?.actionSubject.onNext(.setLoginButton(isLoading: true))
        }, completion: handleLogin(result:))
    }
}
