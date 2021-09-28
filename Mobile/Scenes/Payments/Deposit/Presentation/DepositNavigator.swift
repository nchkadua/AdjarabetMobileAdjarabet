//
//  DepositNavigator.swift
//  Mobile
//
//  Created by Nika Chkadua on 3/22/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

public class DepositNavigator {
    private weak var parent: UIViewController?
    private weak var superview: UIView?
    @Inject(from: .factories) public var visaViewControllerFactory: VisaViewControllerFactory
    @Inject(from: .factories) public var emoneyViewControllerFactory: EmoneyViewControllerFactory
    @Inject(from: .factories) public var applePayViewControllerFactory: ApplePayViewControllerFactory

    // MARK: View Controllers
    private lazy var visaVipViewController: UIViewController = { visaViewControllerFactory.make(params: .init(serviceType: .vip)).wrap(in: ABNavigationController.self) }()
    private lazy var visaRegularViewController: UIViewController = { visaViewControllerFactory.make(params: .init(serviceType: .regular)).wrap(in: ABNavigationController.self) }()
    private lazy var emoneyViewController: UIViewController = { emoneyViewControllerFactory.make().wrap(in: ABNavigationController.self) }()
    private lazy var applePayViewController: UIViewController = { applePayViewControllerFactory.make().wrap(in: ABNavigationController.self) }()

    public init(parent: UIViewController, superview: UIView) {
        self.parent = parent
        self.superview = superview
    }

    enum Destination {
        case visaRegular
        case visaVip
        case emoney
        case applePay
    }

    func navigate(to destination: Destination) {
        switch destination {
        case .visaRegular: navigate(to: visaRegularViewController)
        case .visaVip: navigate(to: visaVipViewController)
        case .emoney: navigate(to: emoneyViewController)
        case .applePay: navigate(to: applePayViewController)
        }
    }

    public func navigate(to viewController: UIViewController) {
        guard let parent = parent,
              let superview = superview
        else { return }

        parent.addChild(viewController)

        superview.removeAllSubViews()
        superview.addSubview(viewController.view)
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        viewController.view.pin(to: superview)

        parent.didMove(toParent: parent)
    }
}
