//
//  ContactUsViewControllerFactory.swift
//  Mobile
//
//  Created by Nika Chkadua on 26.07.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

public protocol ContactUsViewControllerFactory {
    func make(params: ContactUsViewModelParams) -> ContactUsViewController
}

public class DefaultContactUsViewControllerFactory: ContactUsViewControllerFactory {
    public func make(params: ContactUsViewModelParams) -> ContactUsViewController {
        let vc = R.storyboard.contactUs().instantiate(controller: ContactUsViewController.self)!
        vc.viewModel.params = params
        return vc
    }
}
