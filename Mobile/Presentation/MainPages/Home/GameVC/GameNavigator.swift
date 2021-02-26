//
//  GameNavigator.swift
//  Mobile
//
//  Created by Nika Chkadua on 2/8/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

public class GameNavigator: Navigator {
    private weak var viewController: UIViewController?
    @Inject(from: .factories) public var cashFlowViewControllerFactory: CashFlowViewControllerFactory

    public init(viewController: UIViewController) {
        self.viewController = viewController
    }

    public enum Destination {
        case deposit
    }

    public func navigate(to destination: Destination, animated animate: Bool) {
        switch destination {
        case .deposit: navigateToCashFlow(animate: animate, initialPageIndex: 0)
        }
    }

    // MARK: Navigations
    private func navigateToCashFlow(animate: Bool, initialPageIndex: Int) {
        let vc = cashFlowViewControllerFactory.make(params: CashFlowViewModelParams(initialPageIndex: initialPageIndex))
        viewController?.navigationController?.present(vc, animated: animate, completion: nil)
    }
}
