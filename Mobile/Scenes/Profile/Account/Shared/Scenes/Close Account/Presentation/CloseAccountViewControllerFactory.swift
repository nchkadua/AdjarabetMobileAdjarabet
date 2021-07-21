//
//  CloseAccountViewControllerFactory.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 7/21/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

public protocol CloseAccountViewControllerFactory {
    func make(params: CloseAccountViewModelParams) -> CloseAccountViewController
}

public class DefaultCloseAccountViewControllerFactory: CloseAccountViewControllerFactory {
    public func make(params: CloseAccountViewModelParams) -> CloseAccountViewController {
        let vc = R.storyboard.closeAccount().instantiate(controller: CloseAccountViewController.self)!
        vc.viewModel.params = params
        return vc
    }
}
