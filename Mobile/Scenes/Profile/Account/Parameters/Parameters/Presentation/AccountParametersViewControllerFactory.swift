//
//  AccountParametersViewControllerFactory.swift
//  Mobile
//
//  Created by Irakli Shelia on 12/1/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

public protocol AccountParametersViewControllerFactory {
    func make() -> AccountParametersViewController
}

public class DefaultAccountParametersViewControllerFactory: AccountParametersViewControllerFactory {
    public func make() -> AccountParametersViewController {
        R.storyboard.accountParameters().instantiate(controller: AccountParametersViewController.self)!
    }
}
