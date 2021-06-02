//
//  CoreApiPaymentAccountCountDTO.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 1/26/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

struct CoreApiPaymentAccountCountDTO: DataTransferResponse {
    struct Body: Codable {
        let statusCode: Int
        let count: Int

        enum CodingKeys: String, CodingKey {
            case statusCode = "StatusCode"
            case count = "Count"
        }
    }

    typealias Entity = PaymentAccountCount

    static func entity(header: DataTransferResponseDefaultHeader, body: Body) -> Entity? {
        if body.statusCode == AdjarabetCoreStatusCode.STATUS_SUCCESS.rawValue {// FIXME: make common
            return .init(count: body.count)
        } else {
            return nil
        }
    }
}
