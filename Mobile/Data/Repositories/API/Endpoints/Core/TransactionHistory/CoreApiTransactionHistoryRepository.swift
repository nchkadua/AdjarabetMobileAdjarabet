//
//  CoreApiTransactionHistoryRepository.swift
//  Mobile
//
//  Created by Irakli Shelia on 11/30/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

public class CoreApiTransactionHistoryRepository {
    public static let shared = CoreApiTransactionHistoryRepository()
    @Inject private var userSession: UserSessionServices
    @Inject private var dataTransferService: DataTransferService
    private var requestBuilder: CoreRequestBuilder { CoreRequestBuilder() }
    private init() {}
}

extension CoreApiTransactionHistoryRepository: TransactionHistoryRepository {
    private static let maxResult = 10
    public func getUserTransactions(params: GetUserTransactionsParams, completion: @escaping GetUserTransactionsCompletionHandler) {
        guard let sessionId = userSession.sessionId,
              let userId = userSession.userId
        else {
            // TODO: completion(.failure("no session id or user id found"))
            return
        }

        let request = requestBuilder
            .setHeader(key: .cookie, value: sessionId)
            .setBody(key: .req, value: "getUsersTransactions")
            .set(userId: userId)
            .set(fromDate: params.fromDate, toDate: params.toDate)
            .set(transactionType: params.transactionType)
            .set(pageIndex: params.pageIndex)
            .set(providerType: params.providerType)
            .set(maxResult: CoreApiTransactionHistoryRepository.maxResult)
            .build()

        dataTransferService.performTask(expecting: GetUserTransactionsResponse.self,
                                        request: request, respondOnQueue: .main, completion: completion)
    }
}
