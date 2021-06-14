//
//  CoreApiPaymentAccountCountDTO.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 1/26/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

struct CoreApiPaymentAccountCountDTO: CoreDataTransferResponse {
    struct Body: CoreStatusCodeable {
        let statusCode: Int
        let count: Int?

        enum CodingKeys: String, CodingKey {
            case statusCode = "StatusCode"
            case count = "Count"
        }
    }

    typealias Entity = PaymentAccountCount

    static func entitySafely(header: DataTransferResponseDefaultHeader, body: Body) -> Result<Entity, ABError>? {
        guard let count = body.count else { return nil }
        return .success(.init(count: count))
    }
}
