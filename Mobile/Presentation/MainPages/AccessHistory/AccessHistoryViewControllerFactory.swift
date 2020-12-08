//
//  AccessHistoryViewControllerFactory.swift
//  Mobile
//
//  Created by Irakli Shelia on 12/7/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

public protocol AccessHistoryViewControllerFactory {
    func make(params: AccessHistoryViewModelParams) -> AccessHistoryViewController
}

public class DefaultAccessHistoryViewControllerFactory: AccessHistoryViewControllerFactory {
    public func make(params: AccessHistoryViewModelParams) -> AccessHistoryViewController {
        let vc = R.storyboard.accessHistory().instantiate(controller: AccessHistoryViewController.self)!
        vc.viewModel.params = params
        return vc
    }
}
