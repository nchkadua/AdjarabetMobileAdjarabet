//
//  PasswordChangeDTO.swift
//  Mobile
//
//  Created by Nika Chkadua on 6/11/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

struct PasswordChangeDTO: DataTransferResponse {
    struct Body: Codable {
        let statusCode: Int

        enum CodingKeys: String, CodingKey {
            case statusCode = "StatusCode"
        }
    }

    typealias Entity = PasswordChangeEntity

    static func entity(header: DataTransferResponseDefaultHeader, body: Body) -> Entity? {
        .init(statusCode: body.statusCode)
    }
}
