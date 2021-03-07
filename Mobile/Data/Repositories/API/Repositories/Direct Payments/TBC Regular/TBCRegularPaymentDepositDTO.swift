//
//  TBCRegularPaymentDepositDTO.swift
//  Mobile
//
//  Created by Nika Chkadua on 3/4/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

struct TBCRegularPaymentDepositDTO: DataTransferResponse {
    struct Body: Codable {
        let message: String?

        enum CodingKeys: String, CodingKey {
            case message
        }
    }

    typealias Entity = TBCRegularPaymentsEntity

    static func entity(header: DataTransferResponseDefaultHeader, body: Body) -> Entity? { Entity(
        message: body.message
    )}
}
