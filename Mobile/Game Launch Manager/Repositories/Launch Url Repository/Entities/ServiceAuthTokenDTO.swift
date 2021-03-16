//
//  ServiceAuthTokenDTO.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 2/5/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

struct ServiceAuthTokenDTO: DataTransferResponse {
    struct Body: Codable {
        let token: String?

        enum CodingKeys: String, CodingKey {
            case token = "Token"
        }
    }

    typealias Entity = String

    static func entity(header: DataTransferResponseDefaultHeader, body: Body) -> Entity? { body.token }
}
