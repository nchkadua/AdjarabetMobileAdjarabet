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
}

public protocol LoginViewModelInput {
    func viewDidLoad()
    func smsLogin(username: String)
    func login(username: String, password: String)
    func biometryLogin()
}

public protocol LoginViewModelOutput {
    var action: Observable<LoginViewModelOutputAction> { get }
    var route: Observable<LoginViewModelRoute> { get }
    var params: LoginViewModelParams { get }
}

public enum LoginViewModelOutputAction {
    case loginButton(isLoading: Bool)
    case smsLoginButton(isLoading: Bool)
    case biometryButton(isLoading: Bool)
    case configureBiometryButton(available: Bool, icon: UIImage?, title: String?)
}

public enum LoginViewModelRoute {
    case openSMSLogin(params: SMSLoginViewModelParams)
    case openMainTabBar
    case openAlert(title: String, message: String? = nil)
}

public class DefaultLoginViewModel {
    private let actionSubject = PublishSubject<LoginViewModelOutputAction>()
    private let routeSubject = PublishSubject<LoginViewModelRoute>()
    public let params: LoginViewModelParams

    @Inject(from: .useCases) public var loginUseCase: LoginUseCase
    @Inject(from: .useCases) public var smsCodeUseCase: SMSCodeUseCase
    @Inject(from: .useCases) public var userSessionUseCase: UserSessionUseCase

    @Inject public var userSession: UserSessionServices
    @Inject public var biometry: BiometryAuthentication

    public init(params: LoginViewModelParams) {
        self.params = params
    }

    private func loginIfSessionIsAlive() {
        guard let userId = userSession.userId, let sessionId = userSession.sessionId else {return}

        actionSubject.onNext(.biometryButton(isLoading: true))
        userSessionUseCase.execute(userId: userId, sessionId: sessionId) { [weak self] result in
            defer { self?.actionSubject.onNext(.biometryButton(isLoading: false)) }
            switch result {
            case .success: self?.routeSubject.onNext(.openMainTabBar)
            case .failure(let error): self?.routeSubject.onNext(.openAlert(title: error.localizedDescription))
            }
        }
    }
}

extension DefaultLoginViewModel: LoginViewModel {
    public var action: Observable<LoginViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<LoginViewModelRoute> { routeSubject.asObserver() }

    public func viewDidLoad() {
        let isBiometryAvailable = userSession.isLoggedIn && biometry.isAvailable
        actionSubject.onNext(.configureBiometryButton(available: isBiometryAvailable,
                                                      icon: biometry.icon,
                                                      title: biometry.title))
    }

    public func smsLogin(username: String) {
        actionSubject.onNext(.smsLoginButton(isLoading: true))
        smsCodeUseCase.execute(username: username) { [weak self] result in
            defer { self?.actionSubject.onNext(.smsLoginButton(isLoading: false)) }
            switch result {
            case .success: self?.routeSubject.onNext(.openSMSLogin(params: .init(username: username)))
            case .failure(let error): self?.routeSubject.onNext(.openAlert(title: error.localizedDescription))
            }
        }
    }

    public func login(username: String, password: String) {
        actionSubject.onNext(.loginButton(isLoading: true))
        loginUseCase.execute(username: username, password: password) { [weak self] result in
            defer { self?.actionSubject.onNext(.loginButton(isLoading: false)) }
            switch result {
            case .success: self?.routeSubject.onNext(.openMainTabBar)
            case .failure(let error): self?.routeSubject.onNext(.openAlert(title: error.localizedDescription))
            }
        }
    }

    public func biometryLogin() {
        biometry.authenticate { [weak self] result in
            switch result {
            case .success: self?.loginIfSessionIsAlive()
            case .failure(let error): self?.routeSubject.onNext(.openAlert(title: error.localizedDescription))
            }
        }
    }
}
