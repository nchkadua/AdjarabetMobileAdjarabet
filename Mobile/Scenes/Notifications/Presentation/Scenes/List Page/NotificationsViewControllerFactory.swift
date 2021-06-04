//
//  NotificationsViewControllerFactory.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/16/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public protocol NotificationsViewControllerFactory {
    func make() -> NotificationsViewController
}

public class DefaultNotificationsViewControllerFactory: NotificationsViewControllerFactory {
    public func make() -> NotificationsViewController {
        R.storyboard.notifications().instantiate(controller: NotificationsViewController.self)!
    }
}
