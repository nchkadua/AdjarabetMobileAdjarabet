//
//  TBCRegularPaymentsRepository.swift
//  Mobile
//
//  Created by Nika Chkadua on 3/4/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

protocol TBCRegularPaymentsRepository {
    typealias InitDepositHandler = (Result<TBCRegularPaymentsEntity, Error>) -> Void
    func initDeposit(params: InitDepositParams,
                     handler: @escaping InitDepositHandler)
}

struct InitDepositParams {
    let providerId = "c47e7151-a66f-4430-9c2d-adb656c14bb6"
    let serviceName = "ufc"
    let serviceId = 1030
    let saveForRecurring = 0
    let amount: Double
    var accountId: Int64?
}

struct DefaultTBCRegularPaymentsRepository: TBCRegularPaymentsRepository {
    @Inject private var userSession: UserSessionReadableServices
    @Inject private var languageStorage: LanguageStorage
    private var httpRequestBuilder: HttpRequestBuilder { HttpRequestBuilderImpl.createInstance() }
    private var dataTransferService: DataTransferService { DefaultDataTransferService() }

    func initDeposit(params: InitDepositParams, handler: @escaping InitDepositHandler) {
        guard let sessionId = userSession.sessionId,
              let userId = userSession.userId,
              let currencyId = userSession.currencyId,
              let currency = Currency(currencyId: currencyId)
        else {
            handler(.failure(AdjarabetCoreClientError.sessionUninitialzed))
            return
        }

        var body: [String: Any] = [
            "op_type": "initDeposit",
            "user_id": userId,
            "provider_id": params.providerId,
            "service_name": params.serviceName,
            "service_id": params.serviceId,
            "currency": currency.description.abbreviation,
            "save_for_recurring": params.saveForRecurring,
            "lang": languageStorage.currentLanguage.localizableIdentifier,
            "amount": params.amount
        ]

        if let accountId = params.accountId {
            body["account_id"] = accountId
        }

        let headers = [
            "Cookie": sessionId,
            "Origin": AppConstant.coreOriginDomain,
            "Referer": AppConstant.coreOriginDomain,
            "X-Requested-With": "XMLHttpRequest"
        ]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: body, options: []), let jsonStr = String(data: jsonData, encoding: .ascii) else { return }

        let request = httpRequestBuilder
            .set(host: "https://coreapi.adjarabet.com/AuthenticationProxy")
            .set(headers: headers)
            .set(method: HttpMethodPost())
            .set(contentType: ContentTypeUrlEncoded())
            .setBody(key: "data", value: jsonStr)
            .setBody(key: "req", value: "initDeposit")
            .build()

        dataTransferService.performTask(expecting: TBCRegularPaymentDepositDTO.self,
                                        request: request,
                                        respondOnQueue: .main,
                                        completion: handler )
    }
}
