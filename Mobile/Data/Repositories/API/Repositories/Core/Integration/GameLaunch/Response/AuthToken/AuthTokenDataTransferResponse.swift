//
//  AuthTokenDataTransferResponse.swift
//  Mobile
//
//  Created by Nika Chkadua on 12/10/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

public class AuthTokenDataTransferResponse: DataTransferResponse {
    public struct Body: Codable {
        public let token: String?

        enum CodingKeys: String, CodingKey {
            case token = "Token"
        }
    }

    public typealias Entity = AuthTokenEntity

    public static func entity(header: DataTransferResponseDefaultHeader, body: Body) -> Entity {
        AuthTokenEntity(
            token: body.token
        )
    }
}
