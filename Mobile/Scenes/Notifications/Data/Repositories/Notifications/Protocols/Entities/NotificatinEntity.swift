//
//  NotificatinEntity.swift
//  Mobile
//
//  Created by Nika Chkadua on 4/2/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

public struct NotificationItemsEntity {
    var elements: [NotificationEntity]
    var totalItemsCount: Int
    var totalUnreadItemsCount: Int
    var pageCount: Int
    var itemsPerPage: Int

    public struct NotificationEntity: Equatable {
        let id: Int
        let userId: Int
        let createDate: String
        let status: Int
        let header: String
        let content: String
        let contentImg: String
    }
}

enum NotificationStatus: Int {
    case unread = 1
    case read = 2
}
