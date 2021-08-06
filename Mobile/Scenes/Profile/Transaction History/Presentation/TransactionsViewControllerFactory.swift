//
//  TransactionsViewControllerFactory.swift
//  Mobile
//
//  Created by Irakli Shelia on 11/16/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

protocol TransactionsViewControllerFactory {
    func make() -> TransactionsViewController
}

class DefaultTransactionsViewControllerFactory: TransactionsViewControllerFactory {
    func make() -> TransactionsViewController {
        R.storyboard.transactions().instantiate(controller: TransactionsViewController.self)!
    }
}
