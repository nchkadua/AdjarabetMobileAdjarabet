//
//  HighSecurityViewControllerFactory.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 6/25/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

public protocol HighSecurityViewControllerFactory {
    func make(params: HighSecurityViewModelParams) -> HighSecurityViewController
}

public class DefaultHighSecurityViewControllerFactory: HighSecurityViewControllerFactory {
    public func make(params: HighSecurityViewModelParams) -> HighSecurityViewController {
        let vc = R.storyboard.highSecurity().instantiate(controller: HighSecurityViewController.self)!
        vc.viewModel.params = params
        return vc
    }
}
