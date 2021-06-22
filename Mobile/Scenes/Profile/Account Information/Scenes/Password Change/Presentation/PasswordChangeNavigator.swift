//
//  PasswordChangeNavigator.swift
//  Mobile
//
//  Created by Nika Chkadua on 11/25/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public class PasswordChangeNavigator: Navigator {
    @Inject(from: .factories) public var otpFactory: OTPFactory

    private weak var viewController: UIViewController?

    public init(viewController: UIViewController) {
        self.viewController = viewController
    }

    public enum Destination {
        case OTP(params: OTPViewModelParams)
    }

    public func navigate(to destination: Destination, animated animate: Bool) {
        switch destination {
        case .OTP(let params):
            let vc = otpFactory.make(params: params)
            let navC = vc.wrapInNavWith(presentationStyle: .automatic)
            navC.navigationBar.styleForPrimaryPage()
            viewController?.navigationController?.present(navC, animated: animate)
        }
    }
}
