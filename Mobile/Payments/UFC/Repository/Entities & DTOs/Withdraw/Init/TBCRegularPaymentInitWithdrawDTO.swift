//
//  TBCRegularPaymentInitWithdrawDTO.swift
//  Mobile
//
//  Created by Nika Chkadua on 3/15/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

struct TBCRegularPaymentInitWithdrawDTO: DataTransferResponse {
    struct Body: Codable {
        let message: String?
        let code: Int?
        let rules: Rules

        struct Rules: Codable {
            let fee: Double?
            let sessionId: String?

            enum CodingKeys: String, CodingKey {
                case fee
                case sessionId = "session"
            }
        }

        enum CodingKeys: String, CodingKey {
            case message
            case code
            case rules
        }
    }

    typealias Entity = TBCRegularPaymentsInitWithdrawEntity

    static func entity(header: DataTransferResponseDefaultHeader, body: Body) -> TBCRegularPaymentsInitWithdrawEntity? {
        Entity(
            message: body.message,
            code: body.code,
            sessionId: body.rules.sessionId,
            fee: body.rules.fee
        )
    }
}
