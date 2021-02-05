//
//  PaymentAccountCountDataTransferResponse.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 1/26/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

struct PaymentAccountCountDataTransferResponse: DataTransferResponse {

    struct Body: Codable {
        let statusCode: Int?
        let count: Int?

        enum CodingKeys: String, CodingKey {
            case statusCode = "StatusCode"
            case count = "Count"
        }
    }

    typealias Entity = PaymentAccountCount

    static func entity(header: DataTransferResponseDefaultHeader, body: Body) -> Entity? {
        Entity(count: body.count)
    }
}
