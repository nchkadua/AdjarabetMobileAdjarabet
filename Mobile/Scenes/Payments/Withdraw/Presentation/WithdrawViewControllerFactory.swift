//
//  WithdrawViewControllerFactory.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/28/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public protocol WithdrawViewControllerFactory {
    func make() -> WithdrawViewController
}

struct DefaultWithdrawViewControllerFactory: WithdrawViewControllerFactory {
    func make() -> WithdrawViewController {
        R.storyboard.withdraw().instantiate(controller: WithdrawViewController.self)!
    }
}
