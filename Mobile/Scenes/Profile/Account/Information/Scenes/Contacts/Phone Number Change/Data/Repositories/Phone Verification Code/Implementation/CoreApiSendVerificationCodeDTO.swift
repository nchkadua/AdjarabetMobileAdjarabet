//
//  CoreApiSendVerificationCodeDTO.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 6/23/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

struct CoreApiSendVerificationCodeDTO: DataTransferResponse {
    struct Body: CoreStatusCodeable {
        let statusCode: Int

        enum CodingKeys: String, CodingKey {
            case statusCode = "StatusCode"
        }
    }

    typealias Entity = Void

    static func entity(header: DataTransferResponseDefaultHeader, body: Body) -> Result<Entity, ABError>? {
        guard let statusCode = AdjarabetCoreStatusCode(rawValue: body.statusCode),
              statusCode == .OTP_IS_SENT
        else { return .failure(.default) }
        return .success(())
    }
}
