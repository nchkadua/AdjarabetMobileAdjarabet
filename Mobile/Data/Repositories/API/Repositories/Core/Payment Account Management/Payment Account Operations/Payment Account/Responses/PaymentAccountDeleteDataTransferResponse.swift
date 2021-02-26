//
//  PaymentAccountDeleteDataTransferResponse.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 2/18/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

struct PaymentAccountDeleteDataTransferResponse: DataTransferResponse {
    struct Body: Codable {
        let statusCode: Int?

        enum CodingKeys: String, CodingKey {
            case statusCode = "StatusCode"
        }
    }

    typealias Entity = Int

    static func entity(header: DataTransferResponseDefaultHeader, body: Body) -> Entity? { body.statusCode }
}
