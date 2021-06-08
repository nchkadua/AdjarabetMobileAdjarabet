//
//  MainContainerViewControllerFactory.swift
//  Mobile
//
//  Created by Nika Chkadua on 3/31/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

public protocol MainContainerViewControllerFactory {
    func make(params: MainContainerViewModelParams) -> MainContainerViewController
}

public class DefaultMainContainerViewControllerFactory: MainContainerViewControllerFactory {
    public func make(params: MainContainerViewModelParams) -> MainContainerViewController {
        let vc = R.storyboard.mainContainer().instantiate(controller: MainContainerViewController.self)!
        vc.viewModel.params = params
        return vc
    }
}
