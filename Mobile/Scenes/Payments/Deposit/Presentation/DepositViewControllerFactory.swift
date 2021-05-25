//
//  DepositViewControllerFactory.swift
//  Mobile
//
//  Created by Nika Chkadua on 3/22/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

public protocol DepositViewControllerFactory {
    func make(params: DepositViewModelParams) -> DepositViewController
}

public class DefaultDepositViewControllerFactory: DepositViewControllerFactory {
    public func make(params: DepositViewModelParams) -> DepositViewController {
        let vc = R.storyboard.deposit().instantiate(controller: DepositViewController.self)!
        vc.viewModel.params = params
        return vc
    }
}
