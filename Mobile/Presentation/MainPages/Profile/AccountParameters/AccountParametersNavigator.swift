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
    @Inject(from: .factories) public var biometricSettingsViewControllerFactory: BiometricSettingsViewControllerFactory
    @Inject(from: .factories) public var securityLevelsViewControllerFactory: SecurityLevelsViewControllerFactory
    @Inject(from: .factories) public var accessHistoryViewControllerFactory: AccessHistoryViewControllerFactory

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
        case securityLevels
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
        case .securityLevels:
            navigateToSecurityLevels(animate: animate)
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

    // TODO: make private and call correctly through public 'navigate'
    public func navigateToHighSecurity(with params: OTPViewModelParams, animate: Bool) {
        let vc = otpViewControllerFactory.make(params: params)
        let navC = vc.wrapInNavWith(presentationStyle: .automatic)
        navC.navigationBar.styleForPrimaryPage()
        viewController?.navigationController?.present(navC, animated: animate)
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

    private func navigateToSecurityLevels(animate: Bool) {
        let vc = securityLevelsViewControllerFactory.make(params: .default)
        let nvc = vc.wrapInNavWith(presentationStyle: .automatic)
        nvc.navigationBar.styleForPrimaryPage()
        viewController?.navigationController?.present(nvc, animated: animate)
    }

    private func navigateToAccessHistory(animate: Bool) {
        let vc = accessHistoryViewControllerFactory.make(params: .init())
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
