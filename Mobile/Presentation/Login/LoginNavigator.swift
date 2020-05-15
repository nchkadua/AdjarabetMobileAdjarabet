//
//  LoginNavigator.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 5/11/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public class LoginNavigator: Navigator {
    @Inject(from: .factories) public var mainTabBarFactory: MainTabBarFactory
    @Inject(from: .factories) public var smsLoginFactory: SMSLoginFactory

    private weak var viewController: UIViewController?

    public init(viewController: UIViewController) {
        self.viewController = viewController
    }

    public enum Destination {
        case smsLogin(params: SMSLoginViewModelParams)
        case mainTabBar
    }

    public func navigate(to destination: Destination, animated animate: Bool) {
        switch destination {
        case .smsLogin(let params):
            let vc = smsLoginFactory.make(params: params)
            viewController?.navigationController?.pushViewController(vc, animated: animate)
        case .mainTabBar:
            UIApplication.shared.currentWindow?.rootViewController = mainTabBarFactory.make()
        }
    }
}
