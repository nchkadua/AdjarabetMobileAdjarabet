//
//  NotificationComponentViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/12/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public protocol NotificationComponentViewModel: NotificationComponentViewModelInput, NotificationComponentViewModelOutput {
}

public struct NotificationComponentViewModelParams {
    public var notification: Notification
}

public protocol NotificationComponentViewModelInput {
    func didBind()
    func didSelect(at indexPath: IndexPath)
}

public protocol NotificationComponentViewModelOutput {
    var action: Observable<NotificationComponentViewModelOutputAction> { get }
    var params: NotificationComponentViewModelParams { get }
}

public enum NotificationComponentViewModelOutputAction {
    case set(notifiation: Notification)
    case didSelect(notification: Notification)
}

public class DefaultNotificationComponentViewModel {
    public var params: NotificationComponentViewModelParams
    private let actionSubject = PublishSubject<NotificationComponentViewModelOutputAction>()

    public init (params: NotificationComponentViewModelParams) {
        self.params = params
    }
}

extension DefaultNotificationComponentViewModel: NotificationComponentViewModel {
    public var action: Observable<NotificationComponentViewModelOutputAction> { actionSubject.asObserver() }

    public func didBind() {
        actionSubject.onNext(.set(notifiation: params.notification))
    }

    public func didSelect(at indexPath: IndexPath) {
        actionSubject.onNext(.didSelect(notification: params.notification))
    }
}
