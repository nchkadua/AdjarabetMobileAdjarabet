//
//  DoSomethingResponse.swift
//  Mobile
//
//  Created by Irakli Shelia on 12/7/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

public final class GetAccessListResponse: DataTransferResponse {
    struct GetAccessListApiEntity: Codable {
        public let authIp: String?
        public let authTypeId: Int?
        public let authDate: String?
        public let userAgentString: String?
        public let additionalDate: String?
        public let terminationDate: String?
        public let terminationCause: Int?

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

    public struct Body: Codable {
        let statusCode: Int
        let accesList: [GetAccessListApiEntity]

        enum CodingKeys: String, CodingKey {
            case statusCode = "StatusCode"
            case accesList = "Authorization"
        }
    }

    public typealias Entity = [AccessListEntity]

    public static func entity(header: DataTransferResponseDefaultHeader, body: Body) -> Entity? {
        let dateFormatter = ABDateFormater(with: .verbose)
        return body.accesList.compactMap {
            AccessListEntity(ip: $0.authIp,
                             userAgent: $0.userAgentString,
                             date: dateFormatter.date(from: $0.authDate ?? "")) }
    }
}
