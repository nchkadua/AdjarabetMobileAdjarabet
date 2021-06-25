//
//  InitPasswordResetDTO.swift
//  Mobile
//
//  Created by Nika Chkadua on 6/16/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

struct InitPasswordResetDTO: DataTransferResponse {
    struct Body: Codable {
        let statusCode: Int
        let email: String?
        let tel: String?
        let username: String

        enum CodingKeys: String, CodingKey {
            case statusCode = "StatusCode"
            case email = "Email"
            case tel = "Tel"
            case username = "UserName"
        }
    }

    typealias Entity = InitPasswordResetEntity

    static func entity(header: DataTransferResponseDefaultHeader, body: Body) -> Result<Entity, ABError>? {
        guard body.statusCode == AdjarabetCoreStatusCode.STATUS_SUCCESS.rawValue else {
            return .failure(.default)
        }
        return .success(.init(statusCode: body.statusCode, email: body.email, tel: body.tel, username: body.username))
    }
}
