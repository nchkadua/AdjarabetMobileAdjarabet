//
//  AccountInfoNavigator.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/21/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public class AccountInfoNavigator: Navigator {
    private weak var viewController: UIViewController?
    @Inject(from: .factories) public var selfSuspendViewControllerFactory: SelfSuspendViewControllerFactory
    @Inject(from: .factories) public var mailChangeViewControllerFactory: MailChangeViewControllerFactory
    @Inject(from: .factories) public var addressChangeViewControllerFactory: AddressChangeViewControllerFactory
    @Inject(from: .factories) public var passwordChangeViewControllerFactory: PasswordChangeViewControllerFactory
    @Inject(from: .factories) public var phoneNumberChangeViewControllerFactory: PhoneNumberChangeViewControllerFactory
    @Inject(from: .factories) private var closeAccountFactory: CloseAccountViewControllerFactory

    public init(viewController: UIViewController) {
        self.viewController = viewController
    }

    public enum Destination {
        case selfSuspend
        case passwordChange
        case mailChange
        case phoneNumberChange
        case addressChange
        case closeAccount
    }

    public func navigate(to destination: Destination, animated animate: Bool) {
        switch destination {
        case .selfSuspend: navigateToSelfSuspend(animate: animate)
        case .mailChange: navigateToMailChange(animate: animate)
        case .addressChange: navigateToAddressChange(animate: animate)
        case .passwordChange: navigateToPasswordChange(animate: animate)
        case .phoneNumberChange: navigateToPhoneNumberChange(animate: animate)
        case .closeAccount: navigateToCloseAccount()
        }
    }

    private func navigateToSelfSuspend(animate: Bool) {
        let vc = selfSuspendViewControllerFactory.make()
        let navC = vc.wrapInNavWith(presentationStyle: .automatic)
        navC.navigationBar.styleForPrimaryPage()
        viewController?.navigationController?.present(navC, animated: animate, completion: nil)
    }

    private func navigateToMailChange(animate: Bool) {
        let vc = mailChangeViewControllerFactory.make()
        let navC = vc.wrapInNavWith(presentationStyle: .automatic)
        navC.navigationBar.styleForPrimaryPage()
        viewController?.navigationController?.present(navC, animated: animate, completion: nil)
    }

    private func navigateToAddressChange(animate: Bool) {
        let vc = addressChangeViewControllerFactory.make()
        let navC = vc.wrapInNavWith(presentationStyle: .automatic)
        navC.navigationBar.styleForPrimaryPage()
        viewController?.navigationController?.present(navC, animated: animate, completion: nil)
    }

    private func navigateToPasswordChange(animate: Bool) {
        let vc = passwordChangeViewControllerFactory.make()
        let navC = vc.wrapInNavWith(presentationStyle: .automatic)
        navC.navigationBar.styleForPrimaryPage()
        viewController?.navigationController?.present(navC, animated: animate, completion: nil)
    }

    private func navigateToPhoneNumberChange(animate: Bool) {
        let vc = phoneNumberChangeViewControllerFactory.make(params: .init())
        let navC = vc.wrapInNavWith(presentationStyle: .automatic)
        navC.navigationBar.styleForPrimaryPage()
        viewController?.navigationController?.present(navC, animated: animate, completion: nil)
    }

    private func navigateToCloseAccount() {
        let vc = closeAccountFactory.make(params: .init())
        let navc = vc.wrapInNavWith(presentationStyle: .overFullScreen)
        vc.hideNavBar()
        viewController?.navigationController?.present(navc, animated: false, completion: nil)
    }
}
