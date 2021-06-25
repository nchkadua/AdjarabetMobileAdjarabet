//
//  GetPasswordResetCodeDTO.swift
//  Mobile
//
//  Created by Nika Chkadua on 6/17/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

struct GetPasswordResetCodeDTO: DataTransferResponse {
    struct Body: Codable {
        let statusCode: Int
        let userId: Int

        enum CodingKeys: String, CodingKey {
            case statusCode = "StatusCode"
            case userId = "UserID"
        }
    }

    typealias Entity = GetPasswordResetCodeEntity

    static func entity(header: DataTransferResponseDefaultHeader, body: Body) -> Result<Entity, ABError>? {
        guard body.statusCode == AdjarabetCoreStatusCode.STATUS_SUCCESS.rawValue || body.statusCode == AdjarabetCoreStatusCode.OTP_IS_SENT.rawValue  else {
            return .failure(.default)
        }

        return .success(.init(statusCode: body.statusCode, userId: body.userId))
    }
}
