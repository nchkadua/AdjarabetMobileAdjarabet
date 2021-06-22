//
//  VisaViewControllerFactory.swift
//  Mobile
//
//  Created by Nika Chkadua on 3/23/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

public protocol VisaViewControllerFactory {
    func make(params: VisaViewModelParams) -> VisaViewController
}

struct DefaultVisaViewControllerFactory: VisaViewControllerFactory {
    func make(params: VisaViewModelParams) -> VisaViewController {
        let viewController = R.storyboard.visa().instantiate(controller: VisaViewController.self)!
        viewController.viewModel = DefaultVisaViewModel(params: params)
        return viewController
    }
}
