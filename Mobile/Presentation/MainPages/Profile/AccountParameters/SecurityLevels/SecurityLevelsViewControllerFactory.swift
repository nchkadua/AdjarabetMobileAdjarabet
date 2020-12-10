//
//  SecurityLevelsViewControllerFactory.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 12/8/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

public protocol SecurityLevelsViewControllerFactory {
    func make(params: SecurityLevelsViewModelParams) -> SecurityLevelsViewController
}

public class DefaultSecurityLevelsViewControllerFactory: SecurityLevelsViewControllerFactory {
    public func make(params: SecurityLevelsViewModelParams) -> SecurityLevelsViewController {
        let vc = R.storyboard.securityLevels().instantiate(controller: SecurityLevelsViewController.self)!
        vc.viewModel.params = params
        return vc
    }
}
