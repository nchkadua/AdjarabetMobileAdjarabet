//
//  NotificationsRepository.swift
//  Mobile
//
//  Created by Nika Chkadua on 4/2/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

protocol NotificationsRepository {
    typealias NotificationsHandler = (Result<NotificationItemsEntity, Error>) -> Void
    func notifications(params: NotificationParams,
                       handler: @escaping NotificationsHandler)

    typealias NotificationStatusUpdateHandler = (Result<NotificationStatusUpdateMessageEntity, Error>) -> Void
    func read(params: NotificationStatusUpdateParams,
              handler: @escaping NotificationStatusUpdateHandler)
    func delete(params: NotificationStatusUpdateParams,
                handler: @escaping NotificationStatusUpdateHandler)
}

struct NotificationParams {
    let page: Int
    let domain: String
}

struct NotificationStatusUpdateParams {
    let notifiationId: Int
}
