//
//  NotificatinEntity.swift
//  Mobile
//
//  Created by Nika Chkadua on 4/2/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

public struct NotificationItemsEntity: Equatable {
    public static func == (lhs: NotificationItemsEntity, rhs: NotificationItemsEntity) -> Bool {
        return lhs.elements == rhs.elements &&
            lhs.totalItemsCount == rhs.totalItemsCount &&
            lhs.totalUnreadItemsCount == rhs.totalUnreadItemsCount &&
            lhs.pageCount == rhs.pageCount &&
            lhs.itemsPerPage == rhs.itemsPerPage
    }

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
