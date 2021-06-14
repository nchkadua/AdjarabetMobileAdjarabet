//
//  PasswordChangeDTO.swift
//  Mobile
//
//  Created by Nika Chkadua on 6/11/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

struct PasswordChangeDTO: CoreDataTransferResponse {
    struct Body: CoreStatusCodeable {
        let statusCode: Int

        enum CodingKeys: String, CodingKey {
            case statusCode = "StatusCode"
        }
    }

    typealias Entity = PasswordChangeEntity

    static func entitySafely(header: DataTransferResponseDefaultHeader, body: Body) -> Result<Entity, ABError>? {
        .success(.init(statusCode: body.statusCode))
    }
}
