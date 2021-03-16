//
//  TBCRegularPaymentDepositDTO.swift
//  Mobile
//
//  Created by Nika Chkadua on 3/9/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

struct TBCRegularPaymentDepositDTO: DataTransferResponse {
    struct Body: Codable {
        let message: String?
        let code: Int?
        let data: Data

        struct Data: Codable {
            let url: String?
            let parameters: Parameters

            struct Parameters: Codable {
                let transId: String?

                enum CodingKeys: String, CodingKey {
                    case transId = "trans_id"
                }
            }
        }

        enum CodingKeys: String, CodingKey {
            case message
            case code
            case data
        }
    }

    typealias Entity = TBCRegularPaymentsDepositEntity

    static func entity(header: DataTransferResponseDefaultHeader, body: Body) -> Entity? {
        Entity(
            message: body.message,
            code: body.code,
            url: body.data.url,
            transId: body.data.parameters.transId
        )
    }
}
