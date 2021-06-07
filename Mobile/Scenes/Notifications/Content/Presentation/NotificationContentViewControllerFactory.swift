//
//  NotificationContentViewControllerFactory.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/15/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public protocol NotificationContentFactory {
    func make(params: NotificationContentViewModelParams) -> NotificationContentViewController
}

public class DefaultNotificationContentFactory: NotificationContentFactory {
    public func make(params: NotificationContentViewModelParams) -> NotificationContentViewController {
        let vc = R.storyboard.notificationContent().instantiate(controller: NotificationContentViewController.self)!
        vc.viewModel = DefaultNotificationContentViewModel(params: params)
        return vc
    }
}
