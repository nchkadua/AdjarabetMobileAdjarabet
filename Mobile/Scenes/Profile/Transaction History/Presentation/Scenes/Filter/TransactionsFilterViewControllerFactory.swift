//
//  TransactionsFilterViewControllerFactory.swift
//  Mobile
//
//  Created by Nika Chkadua on 11/26/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public protocol TransactionsFilterViewControllerFactory {
    func make(params: TransactionsFilterViewModelParams) -> TransactionsFilterViewController
}

public class DefaultTransactionsFilterViewControllerFactory: TransactionsFilterViewControllerFactory {
    public func make(params: TransactionsFilterViewModelParams) -> TransactionsFilterViewController {
        let vc = R.storyboard.transactionsFilter().instantiate(controller: TransactionsFilterViewController.self)!
        vc.viewModel.params = params
        return vc
    }
}
