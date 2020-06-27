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
    case setLoginButton(isLoading: Bool)
    case setSMSLoginButton(isLoading: Bool)
    case setBiometryButton(isLoading: Bool)
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

    @Inject(from: .useCases) private var loginUseCase: LoginUseCase
    @Inject(from: .useCases) private var smsCodeUseCase: SMSCodeUseCase
    @Inject(from: .useCases) private var userSessionUseCase: UserSessionUseCase

    @Inject private var userSession: UserSessionReadableServices
    @Inject private var biometry: BiometryAuthentication

    public init(params: LoginViewModelParams) {
        self.params = params
    }

    private func loginIfSessionIsAlive() {
        guard let username = userSession.username, let password = userSession.password else {return}

        login(username: username, password: password)
//        guard let userId = userSession.userId, let sessionId = userSession.sessionId else {return}
//
//        actionSubject.onNext(.setBiometryButton(isLoading: true))
//        userSessionUseCase.execute(userId: userId, sessionId: sessionId) { [weak self] result in
//            defer { self?.actionSubject.onNext(.setBiometryButton(isLoading: false)) }
//            switch result {
//            case .success: self?.routeSubject.onNext(.openMainTabBar)
//            case .failure(let error): self?.routeSubject.onNext(.openAlert(title: error.localizedDescription))
//            }
//        }
    }
}

extension DefaultLoginViewModel: LoginViewModel {
    public var action: Observable<LoginViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<LoginViewModelRoute> { routeSubject.asObserver() }

    public func viewDidLoad() {
        let isBiometryAvailable = biometry.isAvailable && userSession.hasUsernameAndPassword
        actionSubject.onNext(.configureBiometryButton(available: isBiometryAvailable,
                                                      icon: biometry.icon,
                                                      title: biometry.title))
    }

    public func smsLogin(username: String) {
        actionSubject.onNext(.setSMSLoginButton(isLoading: true))
        smsCodeUseCase.execute(username: username) { [weak self] result in
            defer { self?.actionSubject.onNext(.setSMSLoginButton(isLoading: false)) }
            switch result {
            case .success: self?.routeSubject.onNext(.openSMSLogin(params: .init(username: username)))
            case .failure(let error): self?.routeSubject.onNext(.openAlert(title: error.localizedDescription))
            }
        }
    }

    public func login(username: String, password: String) {
        actionSubject.onNext(.setLoginButton(isLoading: true))
        loginUseCase.execute(username: username, password: password) { [weak self] result in
            defer { self?.actionSubject.onNext(.setLoginButton(isLoading: false)) }
            switch result {
            case .success(let type):
                switch type {
                case .success:      self?.routeSubject.onNext(.openMainTabBar)
                case .otpRequried:  self?.routeSubject.onNext(.openSMSLogin(params: .init(username: username)))
                }
            case .failure(let error):
                self?.routeSubject.onNext(.openAlert(title: error.localizedDescription))
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
