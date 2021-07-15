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
        case passwordReset(_ username: String?, _ resetType: PasswordResetType, _ contact: String, _ showDismissButton: Bool)
    }

    public func navigate(to destination: Destination, animated animate: Bool) {
        switch destination {
        case .passwordReset(let username, let type, let contact, let show):
            navigateToPasswordReset(username: username, type: type, contact: contact, showDismissButton: show, animate: animate)
        }
    }

    private func navigateToPasswordReset(username: String?, type: PasswordResetType, contact: String, showDismissButton: Bool, animate: Bool) {
        let vc = passwordResetFactory.make(params: .init(username: username, resetType: type, contact: contact, showDismissButton: showDismissButton))
        viewController?.navigationController?.pushViewController(vc, animated: animate)
    }
}
