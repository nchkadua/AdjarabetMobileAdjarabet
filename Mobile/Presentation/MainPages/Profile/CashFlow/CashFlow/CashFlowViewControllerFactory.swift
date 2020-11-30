//
//  CashFlowViewControllerFactory.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/29/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public protocol CashFlowViewControllerFactory {
    func make(params: CashFlowViewModelParams) -> CashFlowViewController
}

public class DefaultCashFlowViewControllerFactory: CashFlowViewControllerFactory {
    public func make(params: CashFlowViewModelParams) -> CashFlowViewController {
        let vc = R.storyboard.cashFlow().instantiate(controller: CashFlowViewController.self)!
        vc.viewModel.params = params
        return vc
    }
}
