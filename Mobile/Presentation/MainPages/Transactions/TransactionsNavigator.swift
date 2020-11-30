//
//  TransactionsNavigator.swift
//  Mobile
//
//  Created by Irakli Shelia on 11/16/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public class TransactionsNavigator: Navigator {
    @Inject(from: .factories) public var transactionDetailsFactory: TransactionDetailsViewControllerFactory
    @Inject(from: .factories) public var transactionsFilterViewControllerFactory: TransactionsFilterViewControllerFactory

    private weak var viewController: UIViewController?

    public init(viewController: UIViewController) {
        self.viewController = viewController
    }

    public enum Destination {
        case transactionDetails(params: TransactionDetailsViewModelParams)
        case filter
    }

    public func navigate(to destination: Destination, animated animate: Bool) {
        switch destination {
        case .transactionDetails(let params):
            navigateToTransactionDetails(params: params, animate: animate)
        case .filter: navigateToFilter(animate: animate)
        }
    }

    private func navigateToTransactionDetails(params: TransactionDetailsViewModelParams, animate: Bool) {
        let vc = transactionDetailsFactory.make(params: params)
        viewController?.navigationController?.present(vc, animated: animate, completion: nil)
    }

    private func navigateToFilter(animate: Bool) {
        let vc = transactionsFilterViewControllerFactory.make()
        let navC = vc.wrapInNavWith(presentationStyle: .automatic)
        navC.navigationBar.styleForPrimaryPage()
        viewController?.navigationController?.present(navC, animated: animate, completion: nil)
    }
}
