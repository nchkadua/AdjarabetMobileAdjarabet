//
//  TransactionDetailsViewControllerFactory.swift
//  Mobile
//
//  Created by Irakli Shelia on 11/19/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

public protocol TransactionDetailsViewControllerFactory {
    func make(params: TransactionDetailsViewModelParams) -> TransactionDetailsViewController
}

public class DefaultTransactionDetailsViewControllerFactory: TransactionDetailsViewControllerFactory {
    public func make(params: TransactionDetailsViewModelParams) -> TransactionDetailsViewController {
        let vc = R.storyboard.transactionDetails().instantiate(controller: TransactionDetailsViewController.self)!
        vc.viewModel = DefaultTransactionDetailsViewModel(params: params)
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = vc
        return vc
    }
}
