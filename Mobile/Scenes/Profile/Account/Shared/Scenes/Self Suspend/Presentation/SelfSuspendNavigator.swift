//
//  SelfSuspendNavigator.swift
//  Mobile
//
//  Created by Nika Chkadua on 11/24/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public class SelfSuspendNavigator: Navigator {
    private weak var viewController: UIViewController?
    @Inject(from: .factories) public var otpFactory: OTPFactory

    public init(viewController: UIViewController) {
        self.viewController = viewController
    }

    public enum Destination {
        case otp(params: OTPViewModelParams)
    }

    public func navigate(to destination: Destination, animated animate: Bool) {
        switch destination {
        case .otp(let params):
            navigateToOTP(params: params, animate: animate)
        }
    }

    private func navigateToOTP(params: OTPViewModelParams, animate: Bool) {
        let vc = otpFactory.make(params: params)
        let navC = vc.wrapInNavWith(presentationStyle: .automatic)
        navC.navigationBar.styleForPrimaryPage()
        viewController?.navigationController?.present(navC, animated: animate)
    }
}
