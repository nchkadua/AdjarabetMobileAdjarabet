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
        let fee: Int?
        let sessionId: String

        enum CodingKeys: String, CodingKey {
            case fee = "fee"
            case sessionId = "session_id"
        }
    }

    typealias Entity = TBCRegularPaymentsEntity

    static func entity(header: DataTransferResponseDefaultHeader, body: Body) -> Entity? { Entity(
        fee: body.fee,
        sessionId: body.sessionId) }
}
