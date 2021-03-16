//
//  TBCRegularPaymentWithdrawDTO.swift
//  Mobile
//
//  Created by Nika Chkadua on 3/15/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

struct TBCRegularPaymentWithdrawDTO: DataTransferResponse {
    struct Body: Codable {
        let message: String?
        let code: Int?

        enum CodingKeys: String, CodingKey {
            case message
            case code
        }
    }

    typealias Entity = TBCRegularPaymentsWithdrawEntity

    static func entity(header: DataTransferResponseDefaultHeader, body: Body) -> TBCRegularPaymentsWithdrawEntity? {
        Entity(
            message: body.message,
            code: body.code
        )
    }
}
