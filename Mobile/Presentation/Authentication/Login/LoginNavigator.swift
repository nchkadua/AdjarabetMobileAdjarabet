//
//  LoginNavigator.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 5/11/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public class LoginNavigator: Navigator {
    @Inject(from: .factories) public var mainTabBarFactory: MainTabBarFactory
    @Inject(from: .factories) public var otpFactory: OTPFactory

    private weak var viewController: UIViewController?

    public init(viewController: UIViewController) {
        self.viewController = viewController
    }

    public enum Destination {
        case OTP(params: OTPViewModelParams)
        case mainTabBar
    }

    public func navigate(to destination: Destination, animated animate: Bool) {
        switch destination {
        case .OTP(let params):
            let vc = otpFactory.make(params: params)
            let navC = vc.wrapInNavWith(presentationStyle: .fullScreen)
            navC.navigationBar.styleForPrimaryPage()
            viewController?.navigationController?.present(navC, animated: animate)
        case .mainTabBar:
            UIApplication.shared.currentWindow?.rootViewController = mainTabBarFactory.make()
        }
    }
}
