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
     Returns list of all payment methods
     */
    typealias ListHandler = (Result<PaymentListEntity, Error>) -> Void
    func list(handler: @escaping ListHandler)
}

// MARK: - Default Implementation
struct DefaultPaymentListRepository: PaymentListRepository {
    private var httpRequestBuilder: HttpRequestBuilder { HttpRequestBuilderImpl.createInstance() }
    private var dataTransferService: DataTransferService { DefaultDataTransferService() }

    func list(handler: @escaping ListHandler) {
        let request = httpRequestBuilder
            .set(host: "https://newstatic.adjarabet.com")
            .set(path: "static/paymentPopUpNavMobileAppleKa.json") // FIXME: Ka, En, Ru
            .set(method: HttpMethodGet())
            .build()

        dataTransferService.performTask(
            expecting: PaymentListDTO.self,
            request: request,
            respondOnQueue: .main,
            completion: handler
        )
    }
}
