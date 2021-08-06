//
//  TransactionsNavigator.swift
//  Mobile
//
//  Created by Irakli Shelia on 11/16/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

class TransactionsNavigator: Navigator {
    @Inject(from: .factories) private var transactionDetailsFactory: TransactionDetailsViewControllerFactory
    @Inject(from: .factories) private var transactionsFilterViewControllerFactory: TransactionsFilterViewControllerFactory

    private weak var viewController: UIViewController?

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    enum Destination {
        case transactionDetails(params: TransactionDetailsViewModelParams)
        case filter(params: TransactionsFilterViewModelParams)
    }

    func navigate(to destination: Destination, animated animate: Bool) {
        switch destination {
        case .transactionDetails(let params):
            navigateToTransactionDetails(params: params, animate: animate)
        case .filter(let params):
            navigateToFilter(params: params, animate: animate)
        }
    }

    private func navigateToTransactionDetails(params: TransactionDetailsViewModelParams, animate: Bool) {
        let vc = transactionDetailsFactory.make(params: params)
        viewController?.navigationController?.present(vc, animated: animate, completion: nil)
    }

    private func navigateToFilter(params: TransactionsFilterViewModelParams, animate: Bool) {
        let vc = transactionsFilterViewControllerFactory.make(params: params)
        let navC = vc.wrapInNavWith(presentationStyle: .automatic)
        navC.navigationBar.styleForPrimaryPage()
        viewController?.navigationController?.present(navC, animated: animate, completion: nil)
    }
}
