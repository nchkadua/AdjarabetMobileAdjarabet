//
//  ResetPasswordDTO.swift
//  Mobile
//
//  Created by Nika Chkadua on 6/17/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

public struct ResetPasswordDTO: DataTransferResponse {
    struct Body: Codable {
        let statusCode: Int

        enum CodingKeys: String, CodingKey {
            case statusCode = "StatusCode"
        }
    }

    typealias Entity = ResetPasswordEntity

    static func entity(header: DataTransferResponseDefaultHeader, body: Body) -> Result<Entity, ABError>? {
        guard body.statusCode == AdjarabetCoreStatusCode.STATUS_SUCCESS.rawValue else { // TODO: apply correct success condition
            return .failure(.init())
        }

        return .success(.init(statusCode: body.statusCode))
    }
}
