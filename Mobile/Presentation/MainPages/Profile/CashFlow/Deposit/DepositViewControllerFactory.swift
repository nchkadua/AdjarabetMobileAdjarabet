//
//  DepositViewControllerFactory.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/28/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public protocol DepositViewControllerFactory {
    func make() -> DepositViewController
}

public class DefaultDepositViewControllerFactory: DepositViewControllerFactory {
    public func make() -> DepositViewController {
        R.storyboard.deposit().instantiate(controller: DepositViewController.self)!
    }
}
