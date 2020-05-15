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
    func smsLogin()
    func login()
}

public protocol LoginViewModelOutput {
    var action: Observable<LoginViewModelOutputAction> { get }
    var route: Observable<LoginViewModelRoute> { get }
    var params: LoginViewModelParams { get }
}

public enum LoginViewModelOutputAction {
}

public enum LoginViewModelRoute {
    case openSMSLogin(params: SMSLoginViewModelParams)
    case openMainTabBar
}

public class DefaultLoginViewModel {
    private let actionSubject = PublishSubject<LoginViewModelOutputAction>()
    private let routeSubject = PublishSubject<LoginViewModelRoute>()
    public let params: LoginViewModelParams

    public init(params: LoginViewModelParams) {
        self.params = params
    }
}

extension DefaultLoginViewModel: LoginViewModel {
    public var action: Observable<LoginViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<LoginViewModelRoute> { routeSubject.asObserver() }

    public func viewDidLoad() {
    }

    public func smsLogin() {
        routeSubject.onNext(.openSMSLogin(params: .init()))
    }

    public func login() {
        routeSubject.onNext(.openMainTabBar)
    }
}
