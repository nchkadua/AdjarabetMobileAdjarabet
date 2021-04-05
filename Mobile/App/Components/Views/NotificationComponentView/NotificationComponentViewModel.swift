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
    public var notification: NotificationItemsEntity.NotificationEntity
}

public protocol NotificationComponentViewModelInput {
    func didBind()
    func didSelect(at indexPath: IndexPath)
    func didDelete(at indexPath: IndexPath)
}

public protocol NotificationComponentViewModelOutput {
    var action: Observable<NotificationComponentViewModelOutputAction> { get }
    var params: NotificationComponentViewModelParams { get }
}

public enum NotificationComponentViewModelOutputAction {
    case set(notifiation: NotificationItemsEntity.NotificationEntity)
    case didSelect(notification: NotificationItemsEntity.NotificationEntity)
    case didDelete(atIndex: IndexPath)
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

    public func didDelete(at indexPath: IndexPath) {
        actionSubject.onNext(.didDelete(atIndex: indexPath))
    }
}
