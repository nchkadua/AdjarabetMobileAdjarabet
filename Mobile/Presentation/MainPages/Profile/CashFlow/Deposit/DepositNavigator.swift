//
//  DepositNavigator.swift
//  Mobile
//
//  Created by Nika Chkadua on 3/22/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

public class DepositNavigator: Navigator {
    private weak var viewController: UIViewController?
    @Inject(from: .factories) public var visaViewControllerFactory: VisaViewControllerFactory
    @Inject(from: .factories) public var emoneyViewControllerFactory: EmoneyViewControllerFactory

    public init(viewController: UIViewController) {
        self.viewController = viewController
    }

    public enum Destination {
    }

    public func navigate(to destination: Destination, animated animate: Bool) {
    }
}
