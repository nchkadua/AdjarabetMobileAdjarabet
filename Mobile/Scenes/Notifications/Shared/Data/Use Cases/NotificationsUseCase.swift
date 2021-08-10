//
//  NotificationsUseCase.swift
//  Mobile
//
//  Created by Nika Chkadua on 4/2/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

protocol NotificationsUseCase {
    typealias NotificationsHandler = (Result<NotificationItemsEntity, ABError>) -> Void
    func notifications(page: Int, domain: String, handler: @escaping NotificationsHandler)

    typealias NotificationStatusUpdateHandler = (Result<NotificationStatusUpdateMessageEntity, ABError>) -> Void
    func read(notificationId: Int, handler: @escaping NotificationStatusUpdateHandler)
    func delete(notificationId: Int, handler: @escaping NotificationStatusUpdateHandler)
}

struct DefaultNotificationsUseCase: NotificationsUseCase {
    @Inject(from: .repositories) private var repo: NotificationsRepository

    func notifications(page: Int, domain: String, handler: @escaping NotificationsHandler) {
        repo.notifications(params: .init(page: page, domain: domain), handler: handler)
    }

    func read(notificationId: Int, handler: @escaping NotificationStatusUpdateHandler) {
        repo.read(params: .init(notifiationId: notificationId), handler: handler)
    }

    func delete(notificationId: Int, handler: @escaping NotificationStatusUpdateHandler) {
        repo.delete(params: .init(notifiationId: notificationId), handler: handler)
    }
}
