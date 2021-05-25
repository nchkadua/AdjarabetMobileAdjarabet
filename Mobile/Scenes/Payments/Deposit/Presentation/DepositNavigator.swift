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
    @Inject(from: .factories) public var applePayViewControllerFactory: ApplePayViewControllerFactory

    public init(viewController: UIViewController) {
        self.viewController = viewController
    }

    public enum Destination {
    }

    public func navigate(to destination: Destination, animated animate: Bool) {
    }

    public func viewController(by paymentMethodType: PaymentMethodType) -> UIViewController? {
        switch paymentMethodType {
        case .tbcVip: return visaViewControllerFactory.make(params: .init(serviceType: .vip)).wrap(in: ABNavigationController.self)
        case .tbcRegular: return visaViewControllerFactory.make(params: .init(serviceType: .regular)).wrap(in: ABNavigationController.self)
        case .eMoney: return emoneyViewControllerFactory.make().wrap(in: ABNavigationController.self)
        case .aPay: return applePayViewControllerFactory.make().wrap(in: ABNavigationController.self)
        }
    }
}
