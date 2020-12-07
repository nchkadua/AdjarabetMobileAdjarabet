//
//  CashFlowNavigator.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/29/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public class CashFlowNavigator: Navigator {
    private weak var viewController: UIViewController?
    @Inject(from: .factories) public var depositViewControllerFactory: DepositViewControllerFactory
    @Inject(from: .factories) public var withdrawViewControllerFactory: WithdrawViewControllerFactory
    @Inject(from: .factories) public var addCardViewControllerFactory: AddCardViewControllerFactory

    public init(viewController: UIViewController) {
        self.viewController = viewController
    }

    public enum Destination {
    }

    public func navigate(to destination: Destination, animated animate: Bool) {
    }

    private func navigateToAddCard(animate: Bool) {
        let vc = addCardViewControllerFactory.make(params: .init())
        viewController?.navigationController?.present(vc, animated: animate, completion: nil)
    }
}
