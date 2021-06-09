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

    static func entity(header: DataTransferResponseDefaultHeader, body: Body) -> Entity? {
        body.statusCode == 134 // FIXME: 134 - OTP_IS_ENABLED
    }
}
