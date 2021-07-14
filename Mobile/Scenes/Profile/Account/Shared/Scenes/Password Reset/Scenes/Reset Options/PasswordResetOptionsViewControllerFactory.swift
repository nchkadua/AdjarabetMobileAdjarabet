//
//  PasswordResetOptionsViewControllerFactory.swift
//  Mobile
//
//  Created by Nika Chkadua on 14.07.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

public protocol PasswordResetOptionsViewControllerFactory {
    func make(params: ResetOptionsViewModelParams) -> PasswordResetOptionsViewController
}

public class DefaultPasswordResetOptionsViewControllerFactory: PasswordResetOptionsViewControllerFactory {
    public func make(params: ResetOptionsViewModelParams) -> PasswordResetOptionsViewController {
        let vc = R.storyboard.passwordResetOptions().instantiate(controller: PasswordResetOptionsViewController.self)!
        vc.viewModel.params = params
        return vc
    }
}
