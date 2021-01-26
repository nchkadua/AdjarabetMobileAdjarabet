//
//  PaymentAccountCountDataTransferResponse.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 1/26/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

public class PaymentAccountCountDataTransferResponse: DataTransferResponse {

    public struct Body: Codable {
        public let statusCode: Int?
        public let count: Int?

        enum CodingKeys: String, CodingKey {
            case statusCode = "StatusCode"
            case count = "Count"
        }
    }

    public typealias Entity = PaymentAccountCount

    public static func entity(header: DataTransferResponseDefaultHeader, body: Body) -> Entity {
        Entity(count: body.count)
    }
}
