//
//  PasswordResetViewControllerFactory.swift
//  Mobile
//
//  Created by Nika Chkadua on 30.06.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

public protocol PasswordResetViewControllerFactory {
    func make(params: PasswordResetViewModelParams) -> PasswordResetViewController
}

public class DefaultPasswordResetViewControllerFactory: PasswordResetViewControllerFactory {
    public func make(params: PasswordResetViewModelParams) -> PasswordResetViewController {
        let vc = R.storyboard.passwordReset().instantiate(controller: PasswordResetViewController.self)!
        vc.viewModel.params = params
        return vc
    }
}
