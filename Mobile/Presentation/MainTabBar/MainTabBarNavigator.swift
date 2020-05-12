//
//  MainTabBarNavigator.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/16/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public class DefaultMainTabBarNavigator: Navigator {
    public let homeVCFacotry = DefaultHomeViewControllerFactory()
    public let sportsVCFactory = DefaultSportsViewControllerFactory()
    public let promotionsVCFactory = DefaultPromotionsViewControllerFactory()
    public let notificationsVCFacotry = DefaultNotificationsViewControllerFactory()

    private weak var viewController: UIViewController?

    public init(viewController: UIViewController) {
        self.viewController = viewController
    }

    public enum Destination {
    }

    public func navigate(to destination: Destination, animated animate: Bool) {
    }

    public func makePages() -> [UIViewController] {
        let home = homeVCFacotry.make()
        let sports = sportsVCFactory.make()
        let promotions = promotionsVCFactory.make()
        let notifications = notificationsVCFacotry.make()

        home.tabBarItem = UITabBarItem(title: nil, image: R.image.tabBar.home(), selectedImage: nil)
        sports.tabBarItem = UITabBarItem(title: nil, image: R.image.tabBar.sports(), selectedImage: nil)
        promotions.tabBarItem = UITabBarItem(title: nil, image: R.image.tabBar.promotions(), selectedImage: nil)
        notifications.tabBarItem = UITabBarItem(title: nil, image: R.image.tabBar.notification(), selectedImage: nil)

        return [home, sports, promotions, notifications].map { $0.wrap(in: ABNavigationController.self) }
    }
}
