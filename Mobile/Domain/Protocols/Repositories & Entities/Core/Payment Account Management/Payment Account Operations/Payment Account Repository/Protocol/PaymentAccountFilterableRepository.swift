//
//  PaymentAccountFilterableRepository.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 4/22/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

protocol PaymentAccountFilterableRepository {
    /**
     Returns payment accounts and their details
     at specified 'providerType' and 'paymentType'
     for the currently authenticated user
     */
    typealias ListHandler = (Result<[PaymentAccountEntity], Error>) -> Void
    func list(params: PaymentAccountFilterableListParams,
              handler: @escaping ListHandler)
}

// list params
struct PaymentAccountFilterableListParams {
    let providerType: ProviderType
    let paymentType: PaymentType

    enum ProviderType {
        case visaRegular
        case visaVip

        var providerId: String {
            switch self {
            case .visaRegular: return "0ad25ba0-c49b-11e3-894d-005056a8fc2a"
            case .visaVip:     return "11e76156-7c0d-7d30-a1f6-0050568d443b"
            }
        }
    }

    enum PaymentType {
        case deposit
        case withdraw

        var stringValue: String {
            switch self {
            case .deposit:  return "deposit"
            case .withdraw: return "withdraw"
            }
        }
    }
}
