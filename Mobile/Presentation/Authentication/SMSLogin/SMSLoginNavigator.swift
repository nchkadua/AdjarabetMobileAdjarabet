//
//  SMSLoginNavigator.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 5/13/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public class SMSLoginNavigator: Navigator {
    @Inject(from: .factories) public var mainTabBarFactory: MainTabBarFactory

    private weak var viewController: UIViewController?

    public init(viewController: UIViewController) {
        self.viewController = viewController
    }

    public enum Destination {
        case mainTabBar
    }

    public func navigate(to destination: Destination, animated animate: Bool) {
        switch destination {
        case .mainTabBar:
            UIApplication.shared.currentWindow?.rootViewController = mainTabBarFactory.make()
        }
    }
}

public protocol SMSLoginFactory {
    func make(params: SMSLoginViewModelParams) -> SMSLoginViewController
}

public class DefaultSMSLoginFactory: SMSLoginFactory {
    public func make(params: SMSLoginViewModelParams) -> SMSLoginViewController {
        let vc = R.storyboard.smsLogin().instantiate(controller: SMSLoginViewController.self)!
        vc.viewModel = DefaultSMSLoginViewModel(params: params)
        return vc
    }
}
