//
//  ProfileNavigator.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/1/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public class ProfileNavigator: Navigator {
    private weak var viewController: UIViewController?
    public var destinationViewController: UIViewController?

    @Inject(from: .factories) private var loginViewControllerFactory: LoginViewControllerFactory
    @Inject(from: .factories) public var accountInfoViewControllerFactory: AccountInfoViewControllerFactory
    @Inject(from: .factories) public var depositViewControllerFactory: DepositViewControllerFactory
    @Inject(from: .factories) public var withdrawViewControllerFactory: WithdrawViewControllerFactory
    @Inject(from: .factories) private var transactionHistoryViewControllerFactory: TransactionsViewControllerFactory
	@Inject(from: .factories) private var myBonusesViewControllerFactory: MyBonusesViewControllerFactory
    @Inject(from: .factories) public var biometricSettingsViewControllerFactory: BiometricSettingsViewControllerFactory
    @Inject(from: .factories) public var accountParametersViewControllerFactory: AccountParametersViewControllerFactory
    @Inject(from: .factories) public var myCardsViewControllerFactory: MyCardsViewControllerFactory
    @Inject(from: .factories) public var documentationViewControllerFactory: DocumentationViewControllerFactory
    @Inject(from: .factories) public var faqViewControllerFactory: FAQCategoriesViewControllerFactory
    @Inject(from: .factories) public var contactUsViewControllerFactory: ContactUsViewControllerFactory

    public init(viewController: UIViewController) {
        self.viewController = viewController
    }

    public enum Destination {
		case accountInformation
		case accountParameters
		case biometryParameters
		case contactUs
		case deposit
		case documentation
		case faq
		case incognitoCard
		case loginPage
        case myCards
        case myBonuses
		case transactionHistory
		case withdraw
    }

    public func navigate(to destination: Destination, animated animate: Bool) {
        switch destination {
        case .deposit: 				navigateToDeposit(animate: animate)
        case .withdraw: 			navigateToWithdraw(animate: animate)
        case .transactionHistory: 	navigateToTransactionHistory(animate: animate)
		case .myBonuses: 			navigateToMyBonuses(animate: animate)
        case .myCards: 				navigateToMyCards(animate: animate)
        case .faq: 					navigateToFAQ(animate: animate)
        case .biometryParameters: 	navigateToBiometricSettings(animate: animate)
        case .accountInformation: 	navigateToAccountInformation(animate: animate)
        case .accountParameters: 	navigateToAccountParameters(animate: animate)
        case .documentation: 		navigateDocumentation(animate: animate)
        case .contactUs: 			navigateToContactUs(animate: animate)
        case .loginPage:			navigateToLogin(animate: animate)
        default:
            break
        }
    }

    public func navigateToMainTabBar() {
        let vc = UIApplication.shared.currentWindow?.rootViewController as? MainContainerViewController
        vc?.jumpToMainTabBar()
    }

    // MARK: Navigations
    private func navigateToDeposit(animate: Bool) {
        let vc = depositViewControllerFactory.make(params: .init())
        destinationViewController = vc
        viewController?.navigationController?.present(vc, animated: animate, completion: nil)
    }

    private func navigateToWithdraw(animate: Bool) {
        let vc = withdrawViewControllerFactory.make()
        viewController?.navigationController?.present(vc, animated: animate, completion: nil)
    }

    private func navigateToTransactionHistory(animate: Bool) {
        let vc = transactionHistoryViewControllerFactory.make()
        viewController?.navigationController?.pushViewController(vc, animated: animate)
    }

	private func navigateToMyBonuses(animate: Bool) {
		let vc = myBonusesViewControllerFactory.make(params: .init())
		viewController?.navigationController?.pushViewController(vc, animated: animate)
	}

    private func navigateToMyCards(animate: Bool) {
        let vc = myCardsViewControllerFactory.make()
        viewController?.navigationController?.pushViewController(vc, animated: animate)
    }

    private func navigateToFAQ(animate: Bool) {
        let vc = faqViewControllerFactory.make(params: .init(showDismissButton: false))
        viewController?.navigationController?.pushViewController(vc, animated: animate)
    }

    private func navigateToBiometricSettings(animate: Bool) {
        let vc = biometricSettingsViewControllerFactory.make()
        viewController?.navigationController?.present(vc, animated: animate, completion: nil)
    }

    private func navigateToAccountInformation(animate: Bool) {
        let vc = accountInfoViewControllerFactory.make()
        viewController?.navigationController?.pushViewController(vc, animated: animate)
    }

    private func navigateToAccountParameters(animate: Bool) {
        let vc = accountParametersViewControllerFactory.make()
        viewController?.navigationController?.pushViewController(vc, animated: animate)
    }

    private func navigateDocumentation(animate: Bool) {
        let vc = documentationViewControllerFactory.make(params: .init())
        viewController?.navigationController?.pushViewController(vc, animated: animate)
    }

    private func navigateToContactUs(animate: Bool) {
        let vc = contactUsViewControllerFactory.make(params: .init(showDismiss: false))
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
