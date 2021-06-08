//
//  MainContainerNavigator.swift
//  Mobile
//
//  Created by Nika Chkadua on 3/31/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

public class MainContainerNavigator: Navigator {
    @Inject(from: .factories) public var mainTabBarFactory: MainTabBarFactory
    @Inject(from: .factories) public var profileFactory: ProfileFactory

    private weak var viewController: UIViewController?

    public init(viewController: UIViewController) {
        self.viewController = viewController
    }

    public enum Destination {
    }

    public func navigate(to destination: Destination, animated animate: Bool) {
    }
}
