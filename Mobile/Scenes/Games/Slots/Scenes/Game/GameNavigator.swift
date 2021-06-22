//
//  GameNavigator.swift
//  Mobile
//
//  Created by Nika Chkadua on 2/8/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

struct GameNavigator: Navigator {
    private weak var viewController: UIViewController?
//    @Inject(from: .factories) private var cashFlowViewControllerFactory: CashFlowViewControllerFactory

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    enum Destination {
        case deposit
    }

    func navigate(to destination: Destination, animated animate: Bool) {
//        switch destination {
//        case .deposit: navigateToCashFlow(animate: animate, initialPageIndex: 0)
//        }
    }

    // MARK: Navigations
//    private func navigateToCashFlow(animate: Bool, initialPageIndex: Int) {
//        let vc = cashFlowViewControllerFactory.make(params: CashFlowViewModelParams(initialPageIndex: initialPageIndex))
//        viewController?.navigationController?.present(vc, animated: animate, completion: nil)
//    }
}
