//
//  WebApiPaymentAccountRepository.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 4/22/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

// TODO: implement with WebApiRepository
struct WebApiPaymentAccountRepository {
    private var requestBuilder: HttpRequestBuilder { HttpRequestBuilderImpl.createInstance() }
    private var userSession: UserSessionServices { UserSession.current }
    private var dataTransferService: DataTransferService { DefaultDataTransferService() }
    private let host = "https://webapi-personal.adjarabet.com"
}

extension WebApiPaymentAccountRepository: PaymentAccountFilterableRepository,
                                          PaymentAccountDeletableRepository {
    func list(params: PaymentAccountFilterableListParams,
              handler: @escaping ListHandler) {
        guard let userId = userSession.userId
        else {
            handler(.failure(AdjarabetCoreClientError.sessionUninitialzed))
            return
        }
        let request = requestBuilder
            .set(host: host)
            .set(path: "getPaymentAccounts")
            .setUrlParam(key: "user_id", value: "\(userId)")
            .setUrlParam(key: "providerId", value: "11e76156-7c0d-7d30-a1f6-0050568d443b")
            .setUrlParam(key: "pay_type", value: "deposit")
            .setUrlParam(key: "domain", value: ".com")
            .set(method: HttpMethodGet())
            .build()
    }

    func delete(params: PaymentAccountDeleteParams,
                handler: @escaping PaymentAccountDeleteHandler) {
        guard let userId = userSession.userId
        else {
            handler(.failure(AdjarabetCoreClientError.sessionUninitialzed))
            return
        }
        let request = requestBuilder
            .set(host: host)
            .set(path: "getPaymentAccounts")
            .setUrlParam(key: "user_id", value: "\(userId)")
            .setUrlParam(key: "card_id", value: "9500918")
            .set(method: HttpMethodGet())
            .build()
    }
}
