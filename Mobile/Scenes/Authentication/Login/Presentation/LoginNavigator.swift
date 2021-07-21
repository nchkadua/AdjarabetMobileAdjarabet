//
//  LoginNavigator.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 5/11/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public class LoginNavigator: Navigator {
    @Inject(from: .factories) public var mainContainerFactory: MainContainerViewControllerFactory
    @Inject(from: .factories) public var otpFactory: OTPFactory
    @Inject(from: .factories) public var passworResetOptionsFactory: PasswordResetOptionsViewControllerFactory
    @Inject(from: .factories) public var faqViewControllerFactory: FAQCategoriesViewControllerFactory

    private weak var viewController: UIViewController?

    public init(viewController: UIViewController) {
        self.viewController = viewController
    }

    public enum Destination {
        case OTP(params: OTPViewModelParams)
        case faq
        case mainTabBar
        case passwordReset
    }

    public func navigate(to destination: Destination, animated animate: Bool) {
        switch destination {
        case .OTP(let params):
            navigateToOTP(params: params, animate: animate)
        case .faq: navigateToFAQ(animate: animate)
        case .mainTabBar:
            openMainTabBar()
        case .passwordReset:
            navigateToPasswordReset(animate: animate)
        }
    }

    private func navigateToOTP(params: OTPViewModelParams, animate: Bool) {
        let vc = otpFactory.make(params: params)
        let navC = vc.wrapInNavWith(presentationStyle: .fullScreen)
        navC.navigationBar.styleForPrimaryPage()
        viewController?.navigationController?.present(navC, animated: animate)
    }

    private func navigateToFAQ(animate: Bool) {
        let vc = faqViewControllerFactory.make(params: .init(showDismissButton: true))
        let navC = vc.wrapInNavWith(presentationStyle: .fullScreen)
        navC.navigationBar.styleForPrimaryPage()
        viewController?.navigationController?.present(navC, animated: animate)
    }

    private func openMainTabBar() {
        UIApplication.shared.currentWindow?.rootViewController = mainContainerFactory.make(params: .init())
    }

    private func navigateToPasswordReset(animate: Bool) {
        let vc = passworResetOptionsFactory.make(params: .init(showUsernameInput: false, shouldShowDismissButton: true))
        let navC = vc.wrapInNavWith(presentationStyle: .fullScreen)
        navC.navigationBar.styleForPrimaryPage()
        viewController?.navigationController?.present(navC, animated: animate)
    }
}
