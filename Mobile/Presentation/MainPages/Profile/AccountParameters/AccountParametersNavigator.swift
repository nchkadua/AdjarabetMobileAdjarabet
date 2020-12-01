//
//  AccountParametersNavigator.swift
//  Mobile
//
//  Created by Irakli Shelia on 12/1/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public class AccountParametersNavigator: Navigator {
    private weak var viewController: UIViewController?
    @Inject(from: .factories) public var selfSuspendViewControllerFactory: SelfSuspendViewControllerFactory
    @Inject(from: .factories) public var passwordChangeViewControllerFactory: PasswordChangeViewControllerFactory
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

    private func navigateToSelfSuspend(animate: Bool) {
        let vc = selfSuspendViewControllerFactory.make()
        let navC = vc.wrapInNavWith(presentationStyle: .automatic)
        navC.navigationBar.styleForPrimaryPage()
        viewController?.navigationController?.present(navC, animated: animate, completion: nil)
    }
}
