//
//  CoreApiPaymentAccountDTO.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 1/26/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

struct CoreApiPaymentAccountDTO: CoreDataTransferResponse {
    struct Body: CoreStatusCodeable {
        let statusCode: Int
        let paymentAccounts: [BodyPaymentAccount]?

        enum CodingKeys: String, CodingKey {
            case statusCode = "StatusCode"
            case paymentAccounts = "PaymentAccounts"
        }
    }

    struct BodyPaymentAccount: Codable {
        let id: Int64
        let accountVisual: String
        let providerName: String?
        let dateCreated: String?

        enum CodingKeys: String, CodingKey {
            case id = "ID"
            case accountVisual = "AccountVisual"
            case providerName = "ProviderName"
            case dateCreated = "DateCreated"
        }
    }

    typealias Entity = [PaymentAccountEntity]

    static func entitySafely(header: DataTransferResponseDefaultHeader, body: Body) -> Result<Entity, ABError>? {
        return .success(body.paymentAccounts?.map {
            PaymentAccountEntity(
                id: $0.id,
                accountVisual: $0.accountVisual,
                providerName: $0.providerName,
                dateCreated: $0.dateCreated
            )
        } ?? [])
    }
}
