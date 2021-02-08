//
//  AddCardNavigator.swift
//  Mobile
//
//  Created by Nika Chkadua on 12/3/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public class AddCardNavigator: Navigator {
    @Inject(from: .factories) public var cardInfoViewControllerFactory: CardInfoViewControllerFactory
    
    private weak var viewController: UIViewController?

    public init(viewController: UIViewController) {
        self.viewController = viewController
    }

    public enum Destination {
        case cardInfo(params: CardInfoViewModelParams)
    }

    public func navigate(to destination: Destination, animated animate: Bool) {
        switch destination {
        case .cardInfo(let params): navigateToCardInfo(params: params, animated: animate)
        }
    }
    
    private func navigateToCardInfo(params: CardInfoViewModelParams, animated: Bool) {
        let vc = cardInfoViewControllerFactory.make(params: params)
        viewController?.navigationController?.pushViewController(vc, animated: animated)
    }
}
