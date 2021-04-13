//
//  WithdrawNavigator.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/28/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import UIKit

class WithdrawNavigator {
    private weak var superview: UIView?
    @Inject(from: .factories) private var visaFactory: WithdrawVisaViewControllerFactory

    // MARK: View Controllers
    private lazy var visaVipViewController: UIViewController = { wrapped(visaFactory.make(with: .init(serviceType: .vip))) }()
    private lazy var visaRegularViewController: UIViewController = { wrapped(visaFactory.make(with: .init(serviceType: .regular))) }()

    init(superview: UIView) {
        self.superview = superview
    }

    enum Destination {
        case visaVip
        case visaRegular
    }

    func navigate(to destination: Destination) {
        switch destination {
        case .visaVip:     navigate(to: visaVipViewController)
        case .visaRegular: navigate(to: visaRegularViewController)
        }
    }

    private func navigate(to viewController: UIViewController) {
        guard let superview = superview else { return }
        superview.removeAllSubViews() // clean superview before navigating
        superview.addSubview(viewController.view)
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        viewController.view.pin(to: superview)
    }

    private func wrapped(_ viewController: UIViewController) -> UINavigationController {
        let navc = viewController.wrapInNavWith(presentationStyle: .automatic)
        navc.navigationBar.styleForPrimaryPage()
        navc.setNavigationBarHidden(true, animated: false)
        return navc
    }
}
