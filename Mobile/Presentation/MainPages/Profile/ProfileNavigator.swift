//
//  ProfileNavigator.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/1/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public class ProfileNavigator: Navigator {
    private weak var viewController: UIViewController?
    @Inject(from: .factories) public var loginViewControllerFactory: LoginViewControllerFactory
    @Inject(from: .factories) public var accountInfoViewControllerFactory: AccountInfoViewControllerFactory
    @Inject(from: .factories) public var cashFlowViewControllerFactory: CashFlowViewControllerFactory
    @Inject(from: .factories) public var biometricSettingsViewControllerFactory: BiometricSettingsViewControllerFactory

    public init(viewController: UIViewController) {
        self.viewController = viewController
    }

    public enum Destination {
        case deposit
        case withdraw
        case transactionHistory
        case myCards
        case myBonuses
        case biometryParameters
        case transferToFriend
        case incognitoCard
        case accountInformation
        case accountParameters
        case loginPage
    }

    public func navigate(to destination: Destination, animated animate: Bool) {
        switch destination {
        case .deposit: navigateToCashFlow(animate: animate, initialPageIndex: 0)
        case .withdraw: navigateToCashFlow(animate: animate, initialPageIndex: 1)
        case .biometryParameters: navigateToBiometricSettings(animate: animate)
        case .accountInformation: navigateToAccountInformation(animate: animate)
        case .loginPage: navigateToLogin(animate: animate)
        default:
            break
        }
    }

    // MARK: Navigations
    private func navigateToCashFlow(animate: Bool, initialPageIndex: Int) {
        let vc = cashFlowViewControllerFactory.make(params: CashFlowViewModelParams(initialPageIndex: initialPageIndex))
        viewController?.navigationController?.present(vc, animated: animate, completion: nil)
    }

    private func navigateToBiometricSettings(animate: Bool) {
        let vc = biometricSettingsViewControllerFactory.make()
        viewController?.navigationController?.present(vc, animated: animate, completion: nil)
    }

    private func navigateToAccountInformation(animate: Bool) {
        let vc = accountInfoViewControllerFactory.make()
        viewController?.navigationController?.pushViewController(vc, animated: animate)
    }

    private func navigateToLogin(animate: Bool) {
        let vc = loginViewControllerFactory.make(params: LoginViewModelParams(showBiometryLoginAutomatically: false))
        vc.modalTransitionStyle = .flipHorizontal
        let navC = vc.wrapInNavWith(presentationStyle: .fullScreen)
        navC.navigationBar.styleForPrimaryPage()

        viewController?.navigationController?.present(navC, animated: animate, completion: nil)
    }
}
