//
//  PhoneNumberChangeViewControllerFactory.swift
//  Mobile
//
//  Created by Nika Chkadua on 11/30/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

public protocol PhoneNumberChangeViewControllerFactory {
    func make(params: PhoneNumberChangeViewModelParams) -> PhoneNumberChangeViewController
}

public class DefaultPhoneNumberChangeViewControllerFactory: PhoneNumberChangeViewControllerFactory {
    public func make(params: PhoneNumberChangeViewModelParams) -> PhoneNumberChangeViewController {
        let vc = R.storyboard.phoneNumberChange().instantiate(controller: PhoneNumberChangeViewController.self)!
        vc.viewModel.params = params
        return vc
    }
}
