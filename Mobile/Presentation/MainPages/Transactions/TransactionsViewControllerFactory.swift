//
//  TransactionsViewControllerFactory.swift
//  Mobile
//
//  Created by Irakli Shelia on 11/16/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

public protocol TransactionsViewControllerFactory {
    func make() -> TransactionsViewController
}

public class DefaultTransactionsViewControllerFactory: TransactionsViewControllerFactory {
    public func make() -> TransactionsViewController {
        R.storyboard.transactions().instantiate(controller: TransactionsViewController.self)!
    }
}
