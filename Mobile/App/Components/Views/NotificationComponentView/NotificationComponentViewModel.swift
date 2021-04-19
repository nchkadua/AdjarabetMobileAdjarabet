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
    func redraw(at indexPath: IndexPath)
    func calculateTimeOf(_ notification: NotificationItemsEntity.NotificationEntity)
}

public protocol NotificationComponentViewModelOutput {
    var action: Observable<NotificationComponentViewModelOutputAction> { get }
    var params: NotificationComponentViewModelParams { get }
}

public enum NotificationComponentViewModelOutputAction {
    case set(notifiation: NotificationItemsEntity.NotificationEntity)
    case didSelect(notification: NotificationItemsEntity.NotificationEntity)
    case didDelete(atIndex: IndexPath)
    case redraw(atIndexPath: IndexPath)
    case setTime(time: String)
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

    public func redraw(at indexPath: IndexPath) {
        actionSubject.onNext(.redraw(atIndexPath: indexPath))
    }

    public func calculateTimeOf(_ notification: NotificationItemsEntity.NotificationEntity) {
        var timeStr = ""
        let difference = Date.minutesBetweenDates(notification.createDate.toDate, Date())
        if difference <= 59 { // 1 hour
            timeStr = "\(String(Int(difference))) \(R.string.localization.notifications_minutes_ago.localized())"
        } else if difference <= 1440 { // 24 hours
            timeStr = "\(String(Int(difference/60))) \(R.string.localization.notifications_hours_ago.localized())"
        } else {
            timeStr = notification.createDate.toDate.formattedStringTimeValue
        }

        actionSubject.onNext(.setTime(time: timeStr))
    }
}
