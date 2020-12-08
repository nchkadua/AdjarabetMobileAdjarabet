//
//  AccountParametersNavigator.swift
//  Mobile
//
//  Created by Irakli Shelia on 12/1/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public class AccountParametersNavigator: Navigator {
    @Inject(from: .factories) public var selfSuspendViewControllerFactory: SelfSuspendViewControllerFactory
    @Inject(from: .factories) public var passwordChangeViewControllerFactory: PasswordChangeViewControllerFactory
    @Inject(from: .factories) public var otpViewControllerFactory: OTPFactory
    @Inject(from: .factories) public var accessHistoryViewControllerFactory: AccessHistoryViewControllerFactory

    private weak var viewController: UIViewController?

    public init(viewController: UIViewController) {
        self.viewController = viewController
    }

    public enum Destination {
        case changePassword
        case highSecurity
        case blockSelf
        case loginHistory
    }

    public func navigate(to destination: Destination, animated animate: Bool) {
        switch destination {
        case .changePassword:
            navigateToPasswordChange(animate: animate)
        case .blockSelf:
            navigateToSelfSuspend(animate: animate)
        case .loginHistory:
            navigateToAccessHistory(animate: animate)
        default:
            break
        }
    }

    private func navigateToPasswordChange(animate: Bool) {
        let vc = passwordChangeViewControllerFactory.make()
        let navC = vc.wrapInNavWith(presentationStyle: .automatic)
        navC.navigationBar.styleForPrimaryPage()
        viewController?.navigationController?.present(navC, animated: animate, completion: nil)
    }

    public func navigateToHighSecurity(with params: OTPViewModelParams, animate: Bool) {
        let vc = otpViewControllerFactory.make(params: params)
        let navC = vc.wrapInNavWith(presentationStyle: .automatic)
        navC.navigationBar.styleForPrimaryPage()
        viewController?.navigationController?.present(navC, animated: animate)
    }

    private func navigateToSelfSuspend(animate: Bool) {
        let vc = selfSuspendViewControllerFactory.make()
        let navC = vc.wrapInNavWith(presentationStyle: .automatic)
        navC.navigationBar.styleForPrimaryPage()
        viewController?.navigationController?.present(navC, animated: animate, completion: nil)
    }

    private func navigateToAccessHistory(animate: Bool) {
        let vc = accessHistoryViewControllerFactory.make(params: .init())
        let navC = vc.wrapInNavWith(presentationStyle: .fullScreen)
        navC.navigationBar.styleForPrimaryPage()
        viewController?.navigationController?.present(navC, animated: animate, completion: nil)
    }
}
