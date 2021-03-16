//
//  UFCWithdrawDTO.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 3/16/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

struct UFCWithdrawDTO: DataTransferResponse {
    struct Body: Codable {
        let message: String?
        let code: Int?

        enum CodingKeys: String, CodingKey {
            case message
            case code
        }
    }

    typealias Entity = UFCWithdrawEntity

    static func entity(header: DataTransferResponseDefaultHeader, body: Body) -> Entity? {
        Entity(
            message: body.message,
            code: body.code
        )
    }
}
