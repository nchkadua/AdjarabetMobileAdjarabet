//
//  NotificationContentViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/15/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public protocol NotificationContentViewModel: NotificationContentViewModelInput, NotificationContentViewModelOutput {
}

public struct NotificationContentViewModelParams {
    public let notification: NotificationItemsEntity.NotificationEntity
}

public protocol NotificationContentViewModelInput {
    func viewDidLoad()
    func openUrl(_ url: String)
}

public protocol NotificationContentViewModelOutput {
    var action: Observable<NotificationContentViewModelOutputAction> { get }
    var route: Observable<NotificationContentViewModelRoute> { get }
    var params: NotificationContentViewModelParams { get }
}

public enum NotificationContentViewModelOutputAction {
    case setupWith(notification: NotificationItemsEntity.NotificationEntity)
}

public enum NotificationContentViewModelRoute {
}

public class DefaultNotificationContentViewModel {
    private let actionSubject = PublishSubject<NotificationContentViewModelOutputAction>()
    private let routeSubject = PublishSubject<NotificationContentViewModelRoute>()
    public let params: NotificationContentViewModelParams

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

    public func openUrl(_ url: String) {
        guard let url = URL(string: url) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
