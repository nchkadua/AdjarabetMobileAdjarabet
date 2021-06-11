//
//  ActionOTPDTO.swift
//  Mobile
//
//  Created by Nika Chkadua on 6/10/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

struct ActionOTPDTO: DataTransferResponse {
    struct Body: Codable {
        let statusCode: Int

        enum CodingKeys: String, CodingKey {
            case statusCode = "StatusCode"
        }
    }

    typealias Entity = ActionOTPEntity

    static func entity(header: DataTransferResponseDefaultHeader, body: Body) -> Entity? {
        .init(statusCode: body.statusCode)
    }
}
