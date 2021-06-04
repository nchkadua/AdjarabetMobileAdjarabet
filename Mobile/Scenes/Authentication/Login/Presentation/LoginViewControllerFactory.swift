//
//  LoginViewControllerFactory.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 9/22/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public protocol LoginViewControllerFactory {
    func make(params: LoginViewModelParams) -> LoginViewController
}

public class DefaultLoginViewControllerFactory: LoginViewControllerFactory {
    public func make(params: LoginViewModelParams) -> LoginViewController {
        let vc = R.storyboard.login().instantiate(controller: LoginViewController.self)!
        vc.viewModel = DefaultLoginViewModel(params: params)
        return vc
    }
}
