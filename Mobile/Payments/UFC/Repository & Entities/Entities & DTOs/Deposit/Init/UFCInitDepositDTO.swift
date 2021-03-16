//
//  UFCInitDepositDTO.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 3/16/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

struct UFCInitDepositDTO: DataTransferResponse {
    struct Body: Codable {
        let message: String?
        let code: Int?
        let rules: Rules

        struct Rules: Codable {
            let sessionId: String?

            enum CodingKeys: String, CodingKey {
                case sessionId = "session"
            }
        }

        enum CodingKeys: String, CodingKey {
            case message
            case code
            case rules
        }
    }

    typealias Entity = UFCInitDepositEntity

    static func entity(header: DataTransferResponseDefaultHeader, body: Body) -> Entity? { Entity(
        message: body.message,
        code: body.code,
        sessionId: body.rules.sessionId
    )}
}
