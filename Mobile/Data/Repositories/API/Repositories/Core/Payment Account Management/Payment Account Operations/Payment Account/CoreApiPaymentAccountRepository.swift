//
//  CoreApiPaymentAccountRepository.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 1/26/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

public struct CoreApiPaymentAccountRepository {
    @Inject private var userSession: UserSessionServices
    @Inject private var dataTransferService: DataTransferService
    private var requestBuilder: CoreRequestBuilder { CoreRequestBuilder() }
}

extension CoreApiPaymentAccountRepository: PaymentAccountRepository {
    public func currentUserPaymentAccountsCount(params: CurrentUserPaymentAccountsCountParams,
                                                completion: @escaping CurrentUserPaymentAccountsCountHandler) {
         guard let sessionId = userSession.sessionId,
               let userId = userSession.userId
         else {
             // TODO: completion(.failure("no session id or user id found"))
             return
         }

         let request = requestBuilder
             .setHeader(key: .cookie, value: sessionId)
             .setBody(key: .req, value: "getPaymentAccountsCount")
             .setBody(key: .userId, value: "\(userId)")
             .build()

         dataTransferService.performTask(expecting: PaymentAccountCountDataTransferResponse.self,
                                         request: request, respondOnQueue: .main, completion: completion)
    }

    public func currentUserPaymentAccounts(params: CurrentUserPaymentAccountsPageParams,
                                           completion: @escaping CurrentUserPaymentAccountsHandler) {
        guard let sessionId = userSession.sessionId,
              let userId = userSession.userId
        else {
            // TODO: completion(.failure("no session id or user id found"))
            return
        }

        let request = requestBuilder
            .setHeader(key: .cookie, value: sessionId)
            .setBody(key: .req, value: "getPaymentAccounts")
            .setBody(key: .userId, value: "\(userId)")
            .setBody(key: "pageIndex", value: "\(params.pageIndex)")
            .setBody(key: "maxResult", value: "\(params.pageCount)")
            .build()

        dataTransferService.performTask(expecting: PaymentAccountDataTransferResponse.self,
                                        request: request, respondOnQueue: .main, completion: completion)
    }
}
