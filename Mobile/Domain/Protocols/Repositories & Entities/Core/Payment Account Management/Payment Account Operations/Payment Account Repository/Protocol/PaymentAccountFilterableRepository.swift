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

struct PaymentAccountFilterableListParams {
    let providerType: ProviderType
    let paymentType: PaymentType

    /// Provider Type Enum
    enum ProviderType {
        case visaRegular
        case visaVip
    }
    /// Payment Type Enum
    enum PaymentType {
        case deposit
        case withdraw
    }
}
