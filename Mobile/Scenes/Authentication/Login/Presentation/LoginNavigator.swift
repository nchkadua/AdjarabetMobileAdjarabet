//
//  LoginNavigator.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 5/11/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

class LoginNavigator: Navigator {
    @Inject(from: .factories) private var mainContainerFactory: MainContainerViewControllerFactory
    @Inject(from: .factories) public var otpFactory: OTPFactory
    @Inject(from: .factories) public var passworResetOptionsFactory: PasswordResetOptionsViewControllerFactory
    @Inject(from: .factories) public var faqViewControllerFactory: FAQCategoriesViewControllerFactory
    @Inject(from: .factories) public var contactUsViewControllerFactory: ContactUsViewControllerFactory
    @Inject(from: .factories) public var notVerifiedUserViewControllerFactory: NotVerifiedUserViewControllerFactory

    private weak var viewController: UIViewController?

    public init(viewController: UIViewController) {
        self.viewController = viewController
    }

    enum Destination {
        case OTP(params: OTPViewModelParams)
        case faq
        case mainTabBar(params: MainContainerViewModelParams)
        case passwordReset
        case contactUs
        case notVerifiedUser
    }

    public func navigate(to destination: Destination, animated animate: Bool) {
        switch destination {
        case .OTP(let params):
            navigateToOTP(params: params, animate: animate)
        case .faq: navigateToFAQ(animate: animate)
        case .mainTabBar(let params):
            openMainTabBar(with: params)
        case .passwordReset:
            navigateToPasswordReset(animate: animate)
        case .contactUs: navigateToContactUs(animate: animate)
        case .notVerifiedUser: navigateToNotVerifiedUser(animate: animate)
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

    private func openMainTabBar(with params: MainContainerViewModelParams) {
        UIApplication.shared.currentWindow?.rootViewController = mainContainerFactory.make(with: params)
    }

    private func navigateToPasswordReset(animate: Bool) {
        let vc = passworResetOptionsFactory.make(params: .init(showUsernameInput: false, shouldShowDismissButton: true))
        let navC = vc.wrapInNavWith(presentationStyle: .fullScreen)
        navC.navigationBar.styleForPrimaryPage()
        viewController?.navigationController?.present(navC, animated: animate)
    }

    private func navigateToContactUs(animate: Bool) {
        let vc = contactUsViewControllerFactory.make(params: .init(showDismiss: true))
        let navC = vc.wrapInNavWith(presentationStyle: .fullScreen)
        navC.navigationBar.styleForPrimaryPage()
        viewController?.navigationController?.present(navC, animated: animate, completion: nil)
    }

    private func navigateToNotVerifiedUser(animate: Bool) {
        let vc = notVerifiedUserViewControllerFactory.make(params: .init())
        viewController?.navigationController?.present(vc, animated: animate, completion: nil)
    }
}
