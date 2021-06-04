//
//  PasswordChangeViewControllerFactory.swift
//  Mobile
//
//  Created by Nika Chkadua on 11/25/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public protocol PasswordChangeViewControllerFactory {
    func make() -> PasswordChangeViewController
}

public class DefaultPasswordChangeViewControllerFactory: PasswordChangeViewControllerFactory {
    public func make() -> PasswordChangeViewController {
        R.storyboard.passwordChange().instantiate(controller: PasswordChangeViewController.self)!
    }
}
