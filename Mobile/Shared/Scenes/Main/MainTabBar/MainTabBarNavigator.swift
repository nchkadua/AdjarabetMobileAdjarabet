//
//  MainTabBarNavigator.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/16/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public class MainTabBarNavigator: Navigator {
    private let homeVCFacotry = DefaultHomeViewControllerFactory()
    private let bonusVCFactory = DefaultBonusViewControllerFactory()
    public let promotionsVCFactory = DefaultPromotionsViewControllerFactory()
    public let notificationsVCFacotry = DefaultNotificationsViewControllerFactory()

    private let homeParams: HomeViewModelParams
    private weak var viewController: UIViewController?

    init(viewController: UIViewController, homeParams: HomeViewModelParams = .init()) {
        self.viewController = viewController
        self.homeParams = homeParams
    }

    public enum Destination {
    }

    public func navigate(to destination: Destination, animated animate: Bool) {
    }

    public func makePages() -> [UIViewController] {
        let home = homeVCFacotry.make(with: homeParams)
        let bonus = bonusVCFactory.make(params: .init())
        let promotions = promotionsVCFactory.make()
        let notifications = notificationsVCFacotry.make()

        home.tabBarItem = UITabBarItem(title: R.string.localization.slots_item_title.localized(), image: R.image.tabBar.home(), selectedImage: nil)
        bonus.tabBarItem = UITabBarItem(title: R.string.localization.bonuses_item_title.localized(), image: R.image.tabBar.bonus(), selectedImage: nil)
        promotions.tabBarItem = UITabBarItem(title: R.string.localization.promos_item_title.localized(), image: R.image.tabBar.promotions(), selectedImage: nil)
        notifications.tabBarItem = UITabBarItem(title: R.string.localization.news_item_title.localized(), image: R.image.tabBar.notification(), selectedImage: nil)
        return [home, bonus, promotions, notifications].map { $0.wrap(in: ABNavigationController.self) }
    }
}

protocol MainTabBarFactory {
    func make(with params: MainTabBarViewModelParams) -> MainTabBarViewController
}

class DefaultMainTabBarFactory: MainTabBarFactory {
    func make(with params: MainTabBarViewModelParams) -> MainTabBarViewController {
        let vc = R.storyboard.mainTabBar().instantiate(controller: MainTabBarViewController.self)!
        vc.viewModel.params = params
        return vc
    }
}
