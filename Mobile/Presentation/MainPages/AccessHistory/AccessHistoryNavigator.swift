//
//  AccessHistoryNavigator.swift
//  Mobile
//
//  Created by Irakli Shelia on 12/7/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public class AccessHistoryNavigator: Navigator {
    private weak var viewController: UIViewController?
    @Inject(from: .factories) private var accessHistoryCalendarFactory: AccessHistoryCalendarViewControllerFactory
    public init(viewController: UIViewController) {
        self.viewController = viewController
    }

    public enum Destination {
        case calendar(params: AccessHistoryCalendarViewModelParams)
    }

    public func navigate(to destination: Destination, animated animate: Bool) {
        switch destination {
        case .calendar(let params):
            navigateToAccessHistoryCalendar(params: params, animate: animate)
        }
    }

    private func navigateToAccessHistoryCalendar(params: AccessHistoryCalendarViewModelParams, animate: Bool) {
        let vc = accessHistoryCalendarFactory.make(params: params)
        let navC = vc.wrapInNavWith(presentationStyle: .automatic)
        navC.navigationBar.styleForPrimaryPage()
        viewController?.navigationController?.present(navC, animated: animate, completion: nil)
    }
}
