//
//  PaymentAccountPagingableRepository.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 4/22/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

protocol PaymentAccountPagingableRepository {
    /**
     Returns count of payment accounts
     for the currently authenticated user
     */
    typealias CountHandler = (Result<PaymentAccountCount, ABError>) -> Void
    func count(params: PaymentAccountPagingableCountParams,
               handler: @escaping CountHandler)

    /**
     Returns payment accounts and their details
     at specified 'pageIndex' and 'pageCount'
     for the currently authenticated user
     */
    typealias PageHandler = (Result<[PaymentAccountEntity], ABError>) -> Void
    func page(params: PaymentAccountPagingablePageParams,
              handler: @escaping PageHandler)
}

// count params
struct PaymentAccountPagingableCountParams { }

// page params
struct PaymentAccountPagingablePageParams {
    let index: Int
    let count: Int
}
