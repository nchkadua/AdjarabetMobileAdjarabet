//
//  CoreApiPaymentAccountDeleteDTO.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 2/18/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

struct CoreApiPaymentAccountDeleteDTO: DataTransferResponse {
    struct Body: Codable {
        let statusCode: Int

        enum CodingKeys: String, CodingKey {
            case statusCode = "StatusCode"
        }
    }

    typealias Entity = Void

    static func entity(header: DataTransferResponseDefaultHeader, body: Body) -> Entity? {
        if body.statusCode == AdjarabetCoreStatusCode.STATUS_SUCCESS.rawValue { // FIXME: make common
            return (())
        } else {
            return nil
        }
    }
}
