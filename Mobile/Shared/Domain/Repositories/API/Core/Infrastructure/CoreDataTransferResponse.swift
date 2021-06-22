//
//  CoreDataTransferResponse.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 6/14/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

protocol CoreStatusCodeable: Codable {
    var statusCode: Int { get }
}

protocol CoreDataTransferResponse: DataTransferResponse where Body: CoreStatusCodeable {
    static func entitySafely(header: Header, body: Body) -> Result<Entity, ABError>?
}

extension CoreDataTransferResponse {
    static func entity(header: Header, body: Body) -> Result<Entity, ABError>? {
        let statusCode = body.statusCode
        if AdjarabetCoreStatusCode.STATUS_SUCCESS.rawValue != statusCode { // TODO: apply correct success condition
            let statusCode = AdjarabetCoreStatusCode(rawValue: statusCode) ?? .UNKNOWN
            let error: ABError = ABError(coreStatusCode: statusCode) ?? .default
            return .failure(error)
        }
        return entitySafely(header: header, body: body)
    }
}
