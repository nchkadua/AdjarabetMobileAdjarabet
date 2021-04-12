//
//  NotificationStatusUpdateMessageDTO.swift
//  Mobile
//
//  Created by Nika Chkadua on 4/12/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

struct NotificationStatusUpdateMessageDTO: DataTransferResponse {
    struct Body: Codable {
        let success: Int
        let statusCode: Int

        enum CodingKeys: String, CodingKey {
            case success
            case statusCode
        }
    }

    typealias Entity = NotificationStatusUpdateMessageEntity

    static func entity(header: DataTransferResponseDefaultHeader, body: Body) -> NotificationStatusUpdateMessageEntity? {
        return .init(success: body.success, statusCode: body.statusCode)
    }
}
