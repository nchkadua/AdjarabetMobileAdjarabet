//
//  CoreApiPaymentAccountDeleteDTO.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 2/18/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

struct CoreApiPaymentAccountDeleteDTO: CoreDataTransferResponse {
    struct Body: CoreStatusCodeable {
        let statusCode: Int

        enum CodingKeys: String, CodingKey {
            case statusCode = "StatusCode"
        }
    }

    typealias Entity = Void

    static func entitySafely(header: DataTransferResponseDefaultHeader, body: Body) -> Result<Entity, ABError>? {
        return .success(())
    }
}
