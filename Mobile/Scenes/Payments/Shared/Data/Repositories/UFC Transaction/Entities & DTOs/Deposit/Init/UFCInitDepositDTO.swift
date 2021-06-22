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
        let code: Int?
        let rules: Rules

        struct Rules: Codable {
            let session: String

            enum CodingKeys: String, CodingKey {
                case session
            }
        }

        enum CodingKeys: String, CodingKey {
            case code
            case rules
        }
    }

    typealias Entity = UFCInitDepositEntity

    static func entity(header: DataTransferResponseDefaultHeader, body: Body) -> Result<Entity, ABError>? {
        if let code = body.code, code != 10 { return nil } // FIXME: Success == 10
        return .success(.init(session: body.rules.session))
    }
}
