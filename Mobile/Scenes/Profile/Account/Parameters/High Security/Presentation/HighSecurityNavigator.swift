//
//  HighSecurityNavigator.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 6/25/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

struct HighSecurityNavigator {
    private weak var viewController: UIViewController?
    @Inject(from: .factories) private var otpFactory: OTPFactory

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    enum Destination {
        case otp(params: OTPViewModelParams)
    }

    func navigate(to destination: Destination) {
        switch destination {
        case .otp(let params):
            let vc = otpFactory.make(params: params)
            let navc = vc.wrapInNavWith(presentationStyle: .automatic)
            navc.navigationBar.styleForPrimaryPage()
            viewController?.navigationController?.present(navc, animated: true)
        }
    }
}
