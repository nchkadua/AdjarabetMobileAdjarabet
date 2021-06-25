//
//  MailChangeViewControllerFactory.swift
//  Mobile
//
//  Created by Nika Chkadua on 11/24/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public protocol MailChangeViewControllerFactory {
    func make() -> MailChangeViewController
}

public class DefaultMailChangeViewControllerFactory: MailChangeViewControllerFactory {
    public func make() -> MailChangeViewController {
        R.storyboard.mailChange().instantiate(controller: MailChangeViewController.self)!
    }
}
