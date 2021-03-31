//
//  OTPNavigator.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 5/13/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public class OTPNavigator: Navigator {
    @Inject(from: .factories) public var mainContainerFactory: MainContainerViewControllerFactory

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
            UIApplication.shared.currentWindow?.rootViewController = mainContainerFactory.make(params: .init())
        }
    }
}

public protocol OTPFactory {
    func make(params: OTPViewModelParams) -> OTPViewController
}

public class DefaultOTPFactory: OTPFactory {
    public func make(params: OTPViewModelParams) -> OTPViewController {
        let vc = R.storyboard.otpLogin().instantiate(controller: OTPViewController.self)!
        vc.viewModel.params = params
        return vc
    }
}
