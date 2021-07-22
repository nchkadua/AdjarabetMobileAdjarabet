//
//  AccountParametersNavigator.swift
//  Mobile
//
//  Created by Irakli Shelia on 12/1/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public class AccountParametersNavigator: Navigator {
    @Inject(from: .factories) private var selfSuspendViewControllerFactory: SelfSuspendViewControllerFactory
    @Inject(from: .factories) private var passwordChangeViewControllerFactory: PasswordChangeViewControllerFactory
    @Inject(from: .factories) private var highSecurityViewControllerFactory: HighSecurityViewControllerFactory
    @Inject(from: .factories) private var biometricSettingsViewControllerFactory: BiometricSettingsViewControllerFactory
    @Inject(from: .factories) private var securityLevelsViewControllerFactory: SecurityLevelsViewControllerFactory
    @Inject(from: .factories) private var accessHistoryViewControllerFactory: AccessHistoryViewControllerFactory
    @Inject(from: .factories) private var closeAccountFactory: CloseAccountViewControllerFactory

    private weak var viewController: UIViewController?

    public init(viewController: UIViewController) {
        self.viewController = viewController
    }

    public enum Destination {
        case changePassword
        case highSecurity
        case biometryAuthorization
        case blockSelf
        case loginHistory
        case securityLevels(params: SecurityLevelsViewModelParams)
        case closeAccount
    }

    public func navigate(to destination: Destination, animated animate: Bool) {
        switch destination {
        case .changePassword:
            navigateToPasswordChange(animate: animate)
        case .blockSelf:
            navigateToSelfSuspend(animate: animate)
        case .biometryAuthorization:
            navigateToBiometryAuthorization(animate: animate)
        case .loginHistory:
            navigateToAccessHistory(animate: animate)
        case .securityLevels(let params):
            navigateToSecurityLevels(with: params, animate: animate)
        case .highSecurity:
            navigateToHighSecurity(animate: animate)
        case .closeAccount:
            navigateToCloseAccount()
        }
    }

    private func navigateToPasswordChange(animate: Bool) {
        let vc = passwordChangeViewControllerFactory.make()
        let navC = vc.wrapInNavWith(presentationStyle: .automatic)
        navC.navigationBar.styleForPrimaryPage()
        viewController?.navigationController?.present(navC, animated: animate, completion: nil)
    }

    private func navigateToHighSecurity(animate: Bool) {
        let vc = highSecurityViewControllerFactory.make()
        let navc = ABPopupViewController.wrapInNav(popup: vc)
        viewController?.navigationController?.present(navc, animated: animate, completion: nil)
    }

    private func navigateToBiometryAuthorization(animate: Bool) {
        let vc = biometricSettingsViewControllerFactory.make()
        viewController?.navigationController?.present(vc, animated: animate, completion: nil)
    }

    private func navigateToSelfSuspend(animate: Bool) {
        let vc = selfSuspendViewControllerFactory.make()
        let navC = vc.wrapInNavWith(presentationStyle: .automatic)
        navC.navigationBar.styleForPrimaryPage()
        viewController?.navigationController?.present(navC, animated: animate, completion: nil)
    }

    private func navigateToSecurityLevels(with params: SecurityLevelsViewModelParams, animate: Bool) {
        let vc = securityLevelsViewControllerFactory.make(params: params)
        let nvc = vc.wrapInNavWith(presentationStyle: .automatic)
        nvc.navigationBar.styleForPrimaryPage()
        viewController?.navigationController?.present(nvc, animated: animate)
    }

    private func navigateToAccessHistory(animate: Bool) {
        let vc = accessHistoryViewControllerFactory.make(params: .init())
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }

    private func navigateToCloseAccount() {
        let vc = closeAccountFactory.make(params: .init())
        let navc = vc.wrapInNavWith(presentationStyle: .overFullScreen)
        vc.hideNavBar()
        viewController?.navigationController?.present(navc, animated: false, completion: nil)
    }
}
