//
//  CoreApiChangeAddressDTO.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 6/17/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

struct CoreApiChangeAddressDTO: CoreDataTransferResponse {
    struct Body: CoreStatusCodeable {
        let statusCode: Int

        enum CodingKeys: String, CodingKey {
            case statusCode = "StatusCode"
        }
    }

    typealias Entity = Void

    static func entitySafely(header: DataTransferResponseDefaultHeader, body: Body) -> Result<Entity, ABError>? {
        .success(())
    }
}
