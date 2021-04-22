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
            .setUrlParam(key: "providerId", value: params.providerType.id)
            .setUrlParam(key: "pay_type", value: params.paymentType.stringValue)
            .setUrlParam(key: "domain", value: ".com") // FIXME: .com ...
            .set(method: HttpMethodGet())
            .build()

        dataTransferService.performTask(
            expecting: WebApiPaymentAccountDTO.self,
            request: request,
            respondOnQueue: .main,
            completion: handler
        )
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
            .set(path: "deletePaymentAccount")
            .setUrlParam(key: "user_id", value: "\(userId)")
            .setUrlParam(key: "card_id", value: "\(params.id)")
            .set(method: HttpMethodGet())
            .build()

        dataTransferService.performTask(
            expecting: WebApiPaymentAccountDeleteDTO.self,
            request: request,
            respondOnQueue: .main,
            completion: handler
        )
    }
}

fileprivate extension PaymentAccountFilterableListParams.ProviderType {
    var id: String {
        switch self {
        case .visaRegular: return "0ad25ba0-c49b-11e3-894d-005056a8fc2a"
        case .visaVip:     return "11e76156-7c0d-7d30-a1f6-0050568d443b"
        }
    }
}

fileprivate extension PaymentAccountFilterableListParams.PaymentType {
    var stringValue: String {
        switch self {
        case .deposit:  return "deposit"
        case .withdraw: return "withdraw"
        }
    }
}
