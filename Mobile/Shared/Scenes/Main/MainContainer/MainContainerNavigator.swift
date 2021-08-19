//
//  MainContainerNavigator.swift
//  Mobile
//
//  Created by Nika Chkadua on 3/31/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

class MainContainerNavigator: Navigator {
    @Inject(from: .factories) var mainTabBarFactory: MainTabBarFactory
    @Inject(from: .factories) var profileFactory: ProfileFactory

    private weak var viewController: UIViewController?

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    enum Destination {}

    func navigate(to destination: Destination, animated animate: Bool) {}
}
