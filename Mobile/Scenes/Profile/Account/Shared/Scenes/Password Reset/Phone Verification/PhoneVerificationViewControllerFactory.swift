//
//  PhoneVerificationViewControllerFactory.swift
//  Mobile
//
//  Created by Nika Chkadua on 30.06.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

public protocol PhoneVerificationViewControllerFactory {
    func make(params: PhoneVerificationViewModelParams) -> PhoneVerificationViewController
}

public class DefaultPhoneVerificationViewControllerFactory: PhoneVerificationViewControllerFactory {
    public func make(params: PhoneVerificationViewModelParams) -> PhoneVerificationViewController {
        let vc = R.storyboard.phoneVerification().instantiate(controller: PhoneVerificationViewController.self)!
        vc.viewModel.params = params
        return vc
    }
}
