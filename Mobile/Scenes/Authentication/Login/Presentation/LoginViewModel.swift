//
//  LoginViewModel.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 5/11/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public protocol LoginViewModel: LoginViewModelInput, LoginViewModelOutput {
}

public struct LoginViewModelParams {
    var showBiometryLoginAutomatically: Bool

    public init (showBiometryLoginAutomatically: Bool) {
        self.showBiometryLoginAutomatically = showBiometryLoginAutomatically
    }
}

public protocol LoginViewModelInput {
    func viewDidLoad()
    func viewDidAppear()
    func smsLogin(username: String)
    func login(username: String, password: String)
    func biometricLogin()
    func languageDidChange()
}

public protocol LoginViewModelOutput {
    var action: Observable<LoginViewModelOutputAction> { get }
    var route: Observable<LoginViewModelRoute> { get }
    var params: LoginViewModelParams { get }
}

public enum LoginViewModelOutputAction {
    case setLoginButton(isLoading: Bool)
    case setSmsLoginButton(isLoading: Bool)
    case setBiometryButton(isLoading: Bool)
    case configureBiometryButton(available: Bool, icon: UIImage?, title: String?)
    case configureQaButton(image: UIImage)
}

public enum LoginViewModelRoute {
    case openOTP(params: OTPViewModelParams)
    case openMainTabBar
    case openAlert(title: String, message: String? = nil)
}

public class DefaultLoginViewModel {
    private let actionSubject = PublishSubject<LoginViewModelOutputAction>()
    private let routeSubject = PublishSubject<LoginViewModelRoute>()
    public let params: LoginViewModelParams
    private let disposeBag = DisposeBag()

    @Inject(from: .useCases) private var loginUseCase: LoginUseCase
    @Inject(from: .useCases) private var smsCodeUseCase: SMSCodeUseCase
    @Inject(from: .useCases) private var biometricLoginUseCase: BiometricLoginUseCase
    @Inject private var biometryStateStorage: BiometryReadableStorage
    @Inject private var languageStorage: LanguageStorage

    public init(params: LoginViewModelParams = LoginViewModelParams(showBiometryLoginAutomatically: true)) {
        self.params = params
    }

    private func handleLogin(result: Result<LoginUseCaseSuccess, ABError>) {
        defer { actionSubject.onNext(.setLoginButton(isLoading: false)) }
        switch result {
        case .success(let type):
            switch type {
            case .success: routeSubject.onNext(.openMainTabBar)
            case .otpRequried(let username): openOTP(username)
            }
        case .failure(let error):
            routeSubject.onNext(.openAlert(title: error.description.description))
        }
    }

    private func openOTP(_ username: String) {
        let otpParams: OTPViewModelParams = .init(vcTitle: R.string.localization.sms_login_page_title.localized(), buttonTitle: R.string.localization.sms_approve.localized(), username: username, otpType: .loginOTP)
        routeSubject.onNext(.openOTP(params: otpParams))
    }
}

extension DefaultLoginViewModel: LoginViewModel {
    public var action: Observable<LoginViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<LoginViewModelRoute> { routeSubject.asObserver() }

    private var biometryIsOn: Bool {
        biometryStateStorage.currentState == .on
    }

    public func viewDidLoad() {
        actionSubject.onNext(.configureBiometryButton(available: biometricLoginUseCase.isAvailable && biometryIsOn,
                                                      icon: biometricLoginUseCase.icon,
                                                      title: biometricLoginUseCase.title))
        getQAImageByLanguage()
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

    public func viewDidAppear() {
        if params.showBiometryLoginAutomatically && biometryIsOn {
            biometricLogin()
        }
    }

    public func languageDidChange() {
        actionSubject.onNext(.configureBiometryButton(available: biometricLoginUseCase.isAvailable && biometryIsOn,
                                                      icon: biometricLoginUseCase.icon,
                                                      title: biometricLoginUseCase.title))
        getQAImageByLanguage()
    }

    public func smsLogin(username: String) {
        actionSubject.onNext(.setSmsLoginButton(isLoading: true))
        smsCodeUseCase.execute(username: username) { [weak self] result in
            defer { self?.actionSubject.onNext(.setSmsLoginButton(isLoading: false)) }
            switch result {
            case .success: self?.openOTP(username)
            case .failure(let error): self?.routeSubject.onNext(.openAlert(title: error.localizedDescription))
            }
        }
    }

    public func login(username: String, password: String) {
        actionSubject.onNext(.setLoginButton(isLoading: true))
        loginUseCase.execute(username: username, password: password, completion: handleLogin(result:))
    }

    public func biometricLogin() {
        biometricLoginUseCase.execute(biometricSuccess: { [weak self] in
            self?.actionSubject.onNext(.setLoginButton(isLoading: true))
        }, completion: handleLogin(result:))
    }
}
