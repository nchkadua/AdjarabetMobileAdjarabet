//
//  HomeViewControllerFactory.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/16/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

protocol HomeViewControllerFactory {
    func make(with params: HomeViewModelParams) -> HomeViewController
}

class DefaultHomeViewControllerFactory: HomeViewControllerFactory {
    func make(with params: HomeViewModelParams) -> HomeViewController {
        let vc = R.storyboard.home().instantiate(controller: HomeViewController.self)!
        vc.viewModel.params = params
        return vc
    }
}
