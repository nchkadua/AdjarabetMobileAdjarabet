//
//  NotificationsUseCase.swift
//  Mobile
//
//  Created by Nika Chkadua on 4/2/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

protocol NotificationsUseCase {
    typealias NotificationsHandler = (Result<NotificationItemsEntity, Error>) -> Void
    func notifications(page: Int, domain: String, handler: @escaping NotificationsHandler)

    typealias NotificationStatusUpdateHandler = (Result<NotificationStatusUpdateMessageEntity, Error>) -> Void
    func read(notificationId: Int, handler: @escaping NotificationStatusUpdateHandler)
    func delete(notificationId: Int, handler: @escaping NotificationStatusUpdateHandler)
}

struct DefaultNotificationsUseCase: NotificationsUseCase {
    @Inject(from: .repositories) private var repo: NotificationsRepository

    func notifications(page: Int, domain: String, handler: @escaping NotificationsHandler) {
        repo.notifications(params: .init(page: page, domain: domain)) { result in
            switch result {
            case .success(let entity): handler(.success(entity))
            case .failure(let error): handler(.failure(error))
            }
        }
    }

    func read(notificationId: Int, handler: @escaping NotificationStatusUpdateHandler) {
        repo.read(params: .init(notifiationId: notificationId)) { result in
            switch result {
            case .success(let entity): handler(.success(entity))
            case .failure(let error): handler(.failure(error))
            }
        }
    }

    func delete(notificationId: Int, handler: @escaping NotificationStatusUpdateHandler) {
        repo.delete(params: .init(notifiationId: notificationId)) { result in
            switch result {
            case .success(let entity): handler(.success(entity))
            case .failure(let error): handler(.failure(error))
            }
        }
    }
}
