//
//  AccountInfoViewControllerFactory.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/21/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public protocol AccountInfoViewControllerFactory {
    func make() -> AccountInfoViewController
}

public class DefaultAccountInfoViewControllerFactory: AccountInfoViewControllerFactory {
    public func make() -> AccountInfoViewController {
        R.storyboard.accountInfo().instantiate(controller: AccountInfoViewController.self)!
    }
}
