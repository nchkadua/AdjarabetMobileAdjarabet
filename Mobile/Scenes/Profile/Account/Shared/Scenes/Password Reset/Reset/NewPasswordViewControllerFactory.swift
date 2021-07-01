//
//  NewPasswordViewControllerFactory.swift
//  Mobile
//
//  Created by Nika Chkadua on 30.06.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

public protocol NewPasswordViewControllerFactory {
    func make(params: NewPasswordViewModelParams) -> NewPasswordViewController
}

public class DefaultNewPasswordViewControllerFactory: NewPasswordViewControllerFactory {
    public func make(params: NewPasswordViewModelParams) -> NewPasswordViewController {
        let vc = R.storyboard.newPassword().instantiate(controller: NewPasswordViewController.self)!
        vc.viewModel.params = params
        return vc
    }
}
