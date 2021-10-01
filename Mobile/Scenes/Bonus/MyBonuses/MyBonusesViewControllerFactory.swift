//
//  MyBonusesViewControllerFactory.swift
//  Mobile
//
//  Created by Giga Khizanishvili on 29.09.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

public protocol MyBonusesViewControllerFactory {
    func make(params: MyBonusesViewModelParams) -> MyBonusesViewController
}

public class DefaultMyBonusesViewControllerFactory: MyBonusesViewControllerFactory {
    public func make(params: MyBonusesViewModelParams) -> MyBonusesViewController {
        let vc = R.storyboard.myBonuses().instantiate(controller: MyBonusesViewController.self)!
        vc.viewModel.params = params
        return vc
    }
}
