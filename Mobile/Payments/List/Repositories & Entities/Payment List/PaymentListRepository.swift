//
//  PaymentListRepository.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 3/6/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

protocol PaymentListRepository {
    /**
     Retusn list of all payment methods
     */
    typealias ListHandler = (Result<Void, Error>) -> Void
    func list(params: PaymentListRepositoryListParams, handler: ListHandler)
}

struct PaymentListRepositoryListParams {
    // ...
}

// MARK: - Default Implementation
struct DefaultPaymentListRepository: PaymentListRepository {
    private var httpRequestBuilder: HttpRequestBuilder { HttpRequestBuilderImpl.createInstance() }
    private var dataTransferService: DataTransferService { DefaultDataTransferService() }

    func list(params: PaymentListRepositoryListParams, handler: ListHandler) {
        let request = httpRequestBuilder
            .set(host: "https://newstatic.adjarabet.com")
            .set(path: "static/paymentPopUpNavAppleKa.json") // FIXME: Ka, En, Ru
            .set(method: HttpMethodGet())
            .build()
    }
}
