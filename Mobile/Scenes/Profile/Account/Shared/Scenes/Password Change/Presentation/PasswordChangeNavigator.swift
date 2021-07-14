//
//  PasswordChangeNavigator.swift
//  Mobile
//
//  Created by Nika Chkadua on 11/25/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public class PasswordChangeNavigator: Navigator {
    @Inject(from: .factories) public var otpFactory: OTPFactory
    @Inject(from: .factories) public var newPasswordFactory: PasswordResetViewControllerFactory

    private weak var viewController: UIViewController?

    public init(viewController: UIViewController) {
        self.viewController = viewController
    }

    public enum Destination {
        case OTP(params: OTPViewModelParams)
        case passwordReset
    }

    public func navigate(to destination: Destination, animated animate: Bool) {
        switch destination {
        case .OTP(let params):
            navigateToOTP(params: params, animate: animate)
        case .passwordReset:
        navigateToPasswordReset(animate: animate)
        }
    }

    private func navigateToOTP(params: OTPViewModelParams, animate: Bool) {
        let vc = otpFactory.make(params: params)
        let navC = vc.wrapInNavWith(presentationStyle: .automatic)
        navC.navigationBar.styleForPrimaryPage()
        viewController?.navigationController?.present(navC, animated: animate)
    }

    private func navigateToPasswordReset(animate: Bool) {
        let vc = newPasswordFactory.make(params: .init(phone: "", mail: ""))
        viewController?.navigationController?.pushViewController(vc, animated: animate)
    }
}
