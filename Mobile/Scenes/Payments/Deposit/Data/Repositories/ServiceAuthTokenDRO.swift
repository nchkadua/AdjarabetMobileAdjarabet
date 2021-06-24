//
//  ServiceAuthTokenDRO.swift
//  Mobile
//
//  Created by Nika Chkadua on 6/15/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

struct ServiceAuthTokenDRO: DataTransferResponse {
    struct Body: Codable {
        let data: Data?

        struct Data: Codable {
            let url: String?

            enum CodingKeys: String, CodingKey {
                case url
            }
        }

        enum CodingKeys: String, CodingKey {
            case data
        }
    }

    typealias Entity = String

    static func entity(header: DataTransferResponseDefaultHeader, body: Body) -> Result<Entity, ABError>? {
        guard let url = body.data?.url else { return nil }
        return .success(url)
    }
}
