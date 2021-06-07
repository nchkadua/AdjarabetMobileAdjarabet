//
//  SelfSuspendViewControllerFactory.swift
//  Mobile
//
//  Created by Nika Chkadua on 11/24/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public protocol SelfSuspendViewControllerFactory {
    func make() -> SelfSuspendViewController
}

public class DefaultSelfSuspendViewControllerFactory: SelfSuspendViewControllerFactory {
    public func make() -> SelfSuspendViewController {
        R.storyboard.selfSuspend().instantiate(controller: SelfSuspendViewController.self)!
    }
}
