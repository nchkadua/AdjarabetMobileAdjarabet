//
//  NotificationsNavigator.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/2/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public class NotificationsNavigator: Navigator {
    @Inject(from: .factories) public var profileFactory: ProfileFactory
    @Inject(from: .factories) public var notificationContentFactory: NotificationContentFactory

    private weak var viewController: UIViewController?

    public init(viewController: UIViewController) {
        self.viewController = viewController
    }

    public enum Destination {
        case notificationContentPage(params: NotificationContentViewModelParams)
    }

    public func navigate(to destination: Destination, animated animate: Bool) {
        switch destination {
        case .notificationContentPage(let params):
            let vc = notificationContentFactory.make(params: params)
            viewController?.navigationController?.pushViewController(vc, animated: animate)
        }
    }
}
