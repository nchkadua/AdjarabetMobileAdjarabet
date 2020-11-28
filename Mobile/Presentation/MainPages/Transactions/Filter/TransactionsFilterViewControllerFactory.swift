//
//  TransactionsFilterViewControllerFactory.swift
//  Mobile
//
//  Created by Nika Chkadua on 11/26/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public protocol TransactionsFilterViewControllerFactory {
    func make() -> TransactionsFilterViewController
}

public class DefaultTransactionsFilterViewControllerFactory: TransactionsFilterViewControllerFactory {
    public func make() -> TransactionsFilterViewController {
        R.storyboard.transactionsFilter().instantiate(controller: TransactionsFilterViewController.self)!
    }
}
