//
//  LoginViewControllerFactory.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 9/22/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

protocol LoginViewControllerFactory {
    func make(params: LoginViewModelParams) -> LoginViewController
}

class DefaultLoginViewControllerFactory: LoginViewControllerFactory {
    func make(params: LoginViewModelParams) -> LoginViewController {
        let vc = R.storyboard.login().instantiate(controller: LoginViewController.self)!
        vc.viewModel = DefaultLoginViewModel(params: params)
        return vc
    }
}
