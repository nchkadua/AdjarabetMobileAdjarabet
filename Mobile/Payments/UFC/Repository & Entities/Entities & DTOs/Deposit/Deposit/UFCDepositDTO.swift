//
//  UFCDepositDTO.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 3/16/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

struct UFCDepositDTO: DataTransferResponse {
    struct Body: Codable {
        let code: Int?
        let data: Data

        struct Data: Codable {
            let url: String
            let parameters: Parameters

            struct Parameters: Codable {
                let transactionId: String

                enum CodingKeys: String, CodingKey {
                    case transactionId = "trans_id"
                }
            }
        }

        enum CodingKeys: String, CodingKey {
            case code
            case data
        }
    }

    typealias Entity = UFCDepositEntity

    static func entity(header: DataTransferResponseDefaultHeader, body: Body) -> Entity? {
        if let code = body.code, code != 10 { return nil } // FIXME: 10 == Success
        return .init(url: body.data.url,
                     transactionId: body.data.parameters.transactionId)
    }
}
