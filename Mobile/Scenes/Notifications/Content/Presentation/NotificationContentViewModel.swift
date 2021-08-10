//
//  NotificationContentViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/15/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

protocol NotificationContentViewModel: BaseViewModel, NotificationContentViewModelInput, NotificationContentViewModelOutput {
}

public struct NotificationContentViewModelParams {
    public let notification: NotificationItemsEntity.NotificationEntity
}

public protocol NotificationContentViewModelInput {
    func viewDidLoad()
    func viewDidAppear()
    func openUrl(_ url: String)
    func calculateTimeOf(_ notification: NotificationItemsEntity.NotificationEntity)
}

public protocol NotificationContentViewModelOutput {
    var action: Observable<NotificationContentViewModelOutputAction> { get }
    var route: Observable<NotificationContentViewModelRoute> { get }
    var params: NotificationContentViewModelParams { get }
}

public enum NotificationContentViewModelOutputAction {
    case setupWith(notification: NotificationItemsEntity.NotificationEntity)
    case setTime(time: String)
}

public enum NotificationContentViewModelRoute {
}

public class DefaultNotificationContentViewModel: DefaultBaseViewModel {
    private let actionSubject = PublishSubject<NotificationContentViewModelOutputAction>()
    private let routeSubject = PublishSubject<NotificationContentViewModelRoute>()
    public let params: NotificationContentViewModelParams
    @Inject(from: .useCases) private var notificationsUseCase: NotificationsUseCase

    public init(params: NotificationContentViewModelParams) {
        self.params = params
    }
}

extension DefaultNotificationContentViewModel: NotificationContentViewModel {
    public var action: Observable<NotificationContentViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<NotificationContentViewModelRoute> { routeSubject.asObserver() }

    public func viewDidLoad() {
        actionSubject.onNext(.setupWith(notification: params.notification))
    }

    public func viewDidAppear() {
        guard params.notification.status == NotificationStatus.unread.rawValue else { return }

        notificationsUseCase.read(notificationId: params.notification.id) { result in
            switch result {
            case .success(let entity): print(entity)
            case .failure(let error): self.show(error: error)
            }
        }
    }

    public func openUrl(_ url: String) {
        guard let url = URL(string: url) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    public func calculateTimeOf(_ notification: NotificationItemsEntity.NotificationEntity) {
        var timeStr = ""
        let difference = Date.minutesBetweenDates(notification.createDate.toDate, Date())
        if difference <= 59 { // 1 hour
            timeStr = "\(String(Int(difference))) \(R.string.localization.notifications_minutes_ago.localized())"
        } else if difference <= 1440 { // 24 hours
            timeStr = "\(String(Int(difference/60))) \(R.string.localization.notifications_hours_ago.localized())"
        } else {
            timeStr = notification.createDate.toDate.formattedStringFullValue
        }

        actionSubject.onNext(.setTime(time: timeStr))
    }
}
