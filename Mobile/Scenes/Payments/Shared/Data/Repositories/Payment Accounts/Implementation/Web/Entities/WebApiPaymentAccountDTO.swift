//
//  WebApiPaymentAccountDTO.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 4/22/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

struct WebApiPaymentAccountDTO: DataTransferResponse {
    struct Body: Codable {
        let success: Int
        let list: [BodyPaymentAccount]?

        enum CodingKeys: String, CodingKey {
            case success
            case list
        }
    }

    struct BodyPaymentAccount: Codable {
        let id: String
        let accountVisual: String
        let brand: String?
        let dateCreated: String?

        enum CodingKeys: String, CodingKey {
            case id = "ID"
            case accountVisual = "AccountVisual"
            case brand = "Brand"
            case dateCreated = "DateCreated"
        }
    }

    typealias Entity = [PaymentAccountEntity]

    static func entity(header: DataTransferResponseDefaultHeader, body: Body) -> Result<Entity, ABError>? {
        guard body.success == 1, // FIXME: make common
              let list = body.list
        else {
            return nil
        }
        return .success(list.compactMap {
            if let id = Int64($0.id) {
                return PaymentAccountEntity(
                    id: id,
                    accountVisual: $0.accountVisual,
                    providerName: $0.brand,
                    dateCreated: $0.dateCreated
                )
            } else {
                return nil
            }
        })
    }
}
