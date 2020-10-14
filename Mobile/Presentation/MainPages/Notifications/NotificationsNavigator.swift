//
//  NotificationsNavigator.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/2/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public class NotificationsNavigator: Navigator {
    @Inject(from: .factories) public var profileFactory: ProfileFactory

    private weak var viewController: UIViewController?

    public init(viewController: UIViewController) {
        self.viewController = viewController
    }

    public enum Destination {
        case profile
    }

    public func navigate(to destination: Destination, animated animate: Bool) {
        switch destination {
        case .profile:
            let vc = profileFactory.make()
            let navC = vc.wrapInNavWith(presentationStyle: .fullScreen)
            navC.navigationBar.styleForSecondaryPage()
            
            viewController?.navigationController?.present(navC, animated: animate, completion: nil)
        }
    }
}
