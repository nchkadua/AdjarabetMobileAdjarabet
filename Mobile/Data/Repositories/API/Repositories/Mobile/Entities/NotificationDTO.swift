//
//  Game.swift
//  Mobile
//
//  Created by Nika Chkadua on 4/2/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

struct NotificationDTO: DataTransferResponse {
    struct Body: Codable {
        let items: [NotificationItemsEntity]?

        struct NotificationItemsEntity: Codable {
            public var id: Int?
            public var userId: Int?
            public var createDate: String?
            public var status: Int?
            public var header: String?
            public var content: String?
            public var contentImg: String?

            enum CodingKeys: String, CodingKey {
                case id = "id"
                case userId = "user_id"
                case createDate = "create_date"
                case status = "status"
                case header = "header"
                case content = "content"
                case contentImg = "content_img"
            }
        }

        enum CodingKeys: String, CodingKey {
            case items
        }
    }

    typealias Entity = NotificationItemsEntity

    static func entity(header: DataTransferResponseDefaultHeader, body: Body) -> Entity? {
        guard let list = body.items else { return nil }

        var elements: [NotificationItemsEntity.NotificationEntity] = []

        list.forEach {
            if let id = $0.id,
               let userId = $0.userId,
               let createDate = $0.createDate,
               let status = $0.status,
               let header = $0.header,
               let content = $0.content,
               let contentImg = $0.contentImg {
               let element = NotificationItemsEntity.NotificationEntity(id: id, userId: userId, createDate: createDate, status: status, header: header, content: content, contentImg: contentImg)

                elements.append(element)
            }
        }

        return .init(elements: elements)
    }
}
