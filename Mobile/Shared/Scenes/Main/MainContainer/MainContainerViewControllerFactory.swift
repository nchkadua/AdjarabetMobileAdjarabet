//
//  MainContainerViewControllerFactory.swift
//  Mobile
//
//  Created by Nika Chkadua on 3/31/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

protocol MainContainerViewControllerFactory {
    func make(with params: MainContainerViewModelParams) -> MainContainerViewController
}

class DefaultMainContainerViewControllerFactory: MainContainerViewControllerFactory {
    func make(with params: MainContainerViewModelParams) -> MainContainerViewController {
        let vc = R.storyboard.mainContainer().instantiate(controller: MainContainerViewController.self)!
        vc.viewModel.params = params
        return vc
    }
}
