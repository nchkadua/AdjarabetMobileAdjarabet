//
//  PaymentAccountDataTransferResponse.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 1/26/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

struct PaymentAccountDataTransferResponse: DataTransferResponse {

    struct Body: Codable {
        let statusCode: Int?
        let paymentAccounts: [BodyPaymentAccount]?

        enum CodingKeys: String, CodingKey {
            case statusCode = "StatusCode"
            case paymentAccounts = "PaymentAccounts"
        }
    }

    struct BodyPaymentAccount: Codable {
        let id: Int64?
        let statusId: Int?
        let isVerified: Bool?
        let providerId: String?
        let providerName: String?
        let providerServiceId: Int64?
        let accountVisual: String?
        let expiryDate: String?
        let dateCreated: String?
        let dateModified: String?

        enum CodingKeys: String, CodingKey {
            case id = "ID"
            case statusId = "StatusID"
            case isVerified = "IsVerified"
            case providerId = "ProviderID"
            case providerName = "ProviderName"
            case providerServiceId = "ProviderServiceID"
            case accountVisual = "AccountVisual"
            case expiryDate = "ExpiryDate"
            case dateCreated = "DateCreated"
            case dateModified = "DateModified"
        }
    }

    typealias Entity = [PaymentAccountEntity]

    static func entity(header: DataTransferResponseDefaultHeader, body: Body) -> Entity? {
        let dateFormatter = ABDateFormater(with: .verbose)
        return body.paymentAccounts?.map {

            PaymentAccountEntity(
                id: $0.id,
                status: Status(statusId: $0.statusId ?? -1),
                isVerified: $0.isVerified,
                providerId: $0.providerId,
                providerName: $0.providerName,
                providerServiceId: $0.providerServiceId,
                accountVisual: $0.accountVisual,
                expiryDate: dateFormatter.date(from: $0.expiryDate ?? ""),
                dateCreated: dateFormatter.date(from: $0.dateCreated ?? ""),
                dateModified: dateFormatter.date(from: $0.dateModified ?? "")
            )

        } ?? []
    }
}
