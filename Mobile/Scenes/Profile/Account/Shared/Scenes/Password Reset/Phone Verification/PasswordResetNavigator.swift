//
//  PasswordResetNavigator.swift
//  Mobile
//
//  Created by Nika Chkadua on 30.06.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

public class PasswordResetNavigator: Navigator {
    @Inject(from: .factories) public var otpFactory: OTPFactory
    @Inject(from: .factories) public var newPasswordFactory: NewPasswordViewControllerFactory

    private weak var viewController: UIViewController?

    public init(viewController: UIViewController) {
        self.viewController = viewController
    }

    public enum Destination {
        case OTP(params: OTPViewModelParams)
        case newPassword(confirmationCode: String)
    }

    public func navigate(to destination: Destination, animated animate: Bool) {
        switch destination {
        case .OTP(let params):
            navigateToOTP(params: params, animate: animate)
        case .newPassword(let confirmationCode):
            navigateToNewPassword(confirmationCode: confirmationCode, animate: animate)
        }
    }

    private func navigateToOTP(params: OTPViewModelParams, animate: Bool) {
        let vc = otpFactory.make(params: params)
        let navC = vc.wrapInNavWith(presentationStyle: .automatic)
        navC.navigationBar.styleForPrimaryPage()
        viewController?.navigationController?.present(navC, animated: animate)
    }

    private func navigateToNewPassword(confirmationCode: String, animate: Bool) {
        let vc = newPasswordFactory.make(params: .init(confirmationCode: confirmationCode))
        viewController?.navigationController?.pushViewController(vc, animated: animate)
    }
}
