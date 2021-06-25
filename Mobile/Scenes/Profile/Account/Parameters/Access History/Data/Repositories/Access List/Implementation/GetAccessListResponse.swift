//
//  DoSomethingResponse.swift
//  Mobile
//
//  Created by Irakli Shelia on 12/7/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

struct GetAccessListResponse: CoreDataTransferResponse {
    struct GetAccessListApiEntity: Codable {
        let authIp: String?
        let authTypeId: Int?
        let authDate: String?
        let userAgentString: String?
        let additionalDate: String?
        let terminationDate: String?
        let terminationCause: Int?

        enum CodingKeys: String, CodingKey {
            case authIp = "AuthIP"
            case authTypeId = "AuthTypeID"
            case authDate = "AuthDate"
            case userAgentString = "UserAgentString"
            case additionalDate = "AdditionalData"
            case terminationDate = "TerminationDate"
            case terminationCause = "TerminationCause"
        }
    }

    struct Body: CoreStatusCodeable {
        let statusCode: Int
        let accesList: [GetAccessListApiEntity]

        enum CodingKeys: String, CodingKey {
            case statusCode = "StatusCode"
            case accesList = "Authorization"
        }
    }

    typealias Entity = [AccessListEntity]

    static func entitySafely(header: DataTransferResponseDefaultHeader, body: Body) -> Result<Entity, ABError>? {
        let dateFormatter = ABDateFormater(with: .verbose)
        return .success(body.accesList.compactMap {
            AccessListEntity(ip: $0.authIp,
                             userAgent: $0.userAgentString,
                             date: dateFormatter.date(from: $0.authDate ?? ""))
            }
        )
    }
}
