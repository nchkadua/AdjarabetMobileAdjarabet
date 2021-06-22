//
//  CoreApiIsOTPEnabledDTO.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 6/9/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

struct CoreApiIsOTPEnabledDTO: DataTransferResponse {
    struct Body: Codable {
        let statusCode: Int

        enum CodingKeys: String, CodingKey {
            case statusCode = "StatusCode"
        }
    }

    typealias Entity = Bool

    static func entity(header: DataTransferResponseDefaultHeader, body: Body) -> Result<Entity, ABError>? {
        .success(body.statusCode == AdjarabetCoreStatusCode.OTP_IS_ENABLED.rawValue)
    }
}
