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

        var requestBuilder = self.requestBuilder
            .setHeader(key: .cookie, value: sessionId)
            .setBody(key: .req, value: "getUsersTransactions")
            .setBody(key: .userId, value: "\(userId)")
            .setBody(key: .fromDate, value: params.fromDate)
            .setBody(key: .toDate, value: params.toDate)
            .setBody(key: .pageIndex, value: "\(params.pageIndex)")
            .setBody(key: .providerType, value: "\(params.providerType)")
            .setBody(key: .maxResult, value: "\(CoreApiTransactionHistoryRepository.maxResult)")

        if let transactionType = params.transactionType {
            requestBuilder = requestBuilder
                .setBody(key: .transactionType, value: "\(transactionType)")
        }

        let request = requestBuilder.build()

        dataTransferService.performTask(expecting: GetUserTransactionsResponse.self,
                                        request: request, respondOnQueue: .main, completion: completion)
    }
}
