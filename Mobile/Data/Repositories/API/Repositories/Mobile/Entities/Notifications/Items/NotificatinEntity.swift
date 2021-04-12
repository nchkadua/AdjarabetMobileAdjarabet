//
//  NotificatinEntity.swift
//  Mobile
//
//  Created by Nika Chkadua on 4/2/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

public struct NotificationItemsEntity {
    let elements: [NotificationEntity]
    let totalItemsCount: Int
    let totalUnreadItemsCount: Int
    let pageCount: Int
    let itemsPerPage: Int

    public struct NotificationEntity {
        let id: Int
        let userId: Int
        let createDate: String
        let status: Int
        let header: String
        let content: String
        let contentImg: String
    }
}
