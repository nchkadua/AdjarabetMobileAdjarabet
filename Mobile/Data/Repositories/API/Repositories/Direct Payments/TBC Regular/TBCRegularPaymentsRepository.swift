//
//  TBCRegularPaymentsRepository.swift
//  Mobile
//
//  Created by Nika Chkadua on 3/4/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

public struct TBCRegularPaymentsRepository: CoreApiRepository { }

public typealias CompletionHandler = (Result<TBCRegularPaymentsEntity, Error>) -> Void

public extension TBCRegularPaymentsRepository {
    private var httpRequestBuilder: HttpRequestBuilder { HttpRequestBuilderImpl.createInstance() }
    func deposit(handler: @escaping CompletionHandler) {
        //376155 376158

        guard let sessionId = userSession.sessionId else {
            return
        }

        let body: [String: Any] = [
            "op_type": "initDeposit",
            "user_id": "608510",
            "provider_id": "c47e7151-a66f-4430-9c2d-adb656c14bb6",
            "service_name": "ufc",
            "service_id": "1030",
            "currency": "GEL",
            "save_for_recurring": 0,
            "account_id": 8823972,    // FIXME: fix with dynamic payment account id
            "amount": 5.00
        ]

        let headers = [
            "Cookie": sessionId
        ]

        let request = httpRequestBuilder
            .set(host: "https://coreapi.adjarabet.com/AuthenticationProxy")
            .set(path: "initDeposit")
            .set(headers: headers)
            .set(method: HttpMethodPost())
            .set(contentType: ContentTypeJson())
            .setBody(json: body)
            .build()

        dataTransferService.performTask(expecting: TBCRegularPaymentDepositDTO.self,
                                        request: request,
                                        respondOnQueue: .main,
                                        completion: handler )
    }
}
