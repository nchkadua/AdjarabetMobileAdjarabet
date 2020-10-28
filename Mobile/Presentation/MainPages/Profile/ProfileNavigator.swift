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

    public init(viewController: UIViewController) {
        self.viewController = viewController
    }

    public enum Destination {
        case deposit
        case withdraw
        case transactionHistory
        case myCards
        case myBonuses
        case balanceManagement
        case transferToFriend
        case incognitoCard
        case accountInformation
        case accountParameters
        case loginPage
    }

    public func navigate(to destination: Destination, animated animate: Bool) {
        switch destination {
        case .loginPage:
            let vc = loginViewControllerFactory.make()
            vc.modalTransitionStyle = .flipHorizontal
            let navC = vc.wrapInNavWith(presentationStyle: .fullScreen)
            navC.navigationBar.styleForPrimaryPage()

            viewController?.navigationController?.present(navC, animated: animate, completion: nil)
        case .accountInformation:
            let vc = accountInfoViewControllerFactory.make()
            viewController?.navigationController?.pushViewController(vc, animated: animate)
        default:
            break
        }
    }
}
