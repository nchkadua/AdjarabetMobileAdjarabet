//
//  ResetOptionsNavigator.swift
//  Mobile
//
//  Created by Nika Chkadua on 14.07.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

public class ResetOptionsNavigator: Navigator {
    @Inject(from: .factories) public var passwordResetFactory: PasswordResetViewControllerFactory

    private weak var viewController: UIViewController?

    public init(viewController: UIViewController) {
        self.viewController = viewController
    }

    public enum Destination {
        case passwordReset(_ resetType: PasswordResetType)
    }

    public func navigate(to destination: Destination, animated animate: Bool) {
        switch destination {
        case .passwordReset(let type):
            navigateToPasswordReset(type: type, animate: animate)
        }
    }

    private func navigateToPasswordReset(type: PasswordResetType, animate: Bool) {
        let vc = passwordResetFactory.make(params: .init(phone: "", mail: ""))
        viewController?.navigationController?.pushViewController(vc, animated: animate)
    }
}
