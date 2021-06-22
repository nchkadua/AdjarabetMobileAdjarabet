//
//  ActionOTPDTO.swift
//  Mobile
//
//  Created by Nika Chkadua on 6/10/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

struct ActionOTPDTO: CoreDataTransferResponse {
    struct Body: CoreStatusCodeable {
        let statusCode: Int

        enum CodingKeys: String, CodingKey {
            case statusCode = "StatusCode"
        }
    }

    typealias Entity = ActionOTPEntity

    static func entitySafely(header: DataTransferResponseDefaultHeader, body: Body) -> Result<Entity, ABError>? {
        .success(.init(statusCode: body.statusCode))
    }
}
