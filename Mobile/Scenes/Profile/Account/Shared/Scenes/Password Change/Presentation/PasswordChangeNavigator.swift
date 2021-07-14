//
//  PasswordChangeNavigator.swift
//  Mobile
//
//  Created by Nika Chkadua on 11/25/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public class PasswordChangeNavigator: Navigator {
    @Inject(from: .factories) public var otpFactory: OTPFactory
    @Inject(from: .factories) public var passwordResetFactory: PasswordResetViewControllerFactory
    @Inject(from: .factories) public var passworResetOptionsFactory: PasswordResetOptionsViewControllerFactory

    private weak var viewController: UIViewController?

    public init(viewController: UIViewController) {
        self.viewController = viewController
    }

    public enum Destination {
        case OTP(params: OTPViewModelParams)
        case passwordReset(_ resetType: PasswordResetType)
    }

    public func navigate(to destination: Destination, animated animate: Bool) {
        switch destination {
        case .OTP(let params):
            navigateToOTP(params: params, animate: animate)
        case .passwordReset(let type):
            navigateToPasswordReset(type: type, animate: animate)
        }
    }

    private func navigateToOTP(params: OTPViewModelParams, animate: Bool) {
        let vc = otpFactory.make(params: params)
        let navC = vc.wrapInNavWith(presentationStyle: .automatic)
        navC.navigationBar.styleForPrimaryPage()
        viewController?.navigationController?.present(navC, animated: animate)
    }

    private func navigateToPasswordReset(type: PasswordResetType, animate: Bool) {
        let vc = passworResetOptionsFactory.make(params: .init(showUsernameInput: true))
        viewController?.navigationController?.pushViewController(vc, animated: animate)
    }
}
