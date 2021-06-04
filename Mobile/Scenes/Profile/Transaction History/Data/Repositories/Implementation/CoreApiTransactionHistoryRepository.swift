//
//  CoreApiTransactionHistoryRepository.swift
//  Mobile
//
//  Created by Irakli Shelia on 11/30/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

public struct CoreApiTransactionHistoryRepository: CoreApiRepository { }

extension CoreApiTransactionHistoryRepository: TransactionHistoryRepository {
    private static let maxResult = 10

    public func getUserTransactions(params: GetUserTransactionsParams, completion: @escaping GetUserTransactionsCompletionHandler) {
        performTask(expecting: GetUserTransactionsResponse.self, completion: completion) { requestBuilder in
            var requestBuilder = requestBuilder
                .setBody(key: .req, value: "getUsersTransactions")
                .setBody(key: .fromDate, value: params.fromDate)
                .setBody(key: .toDate, value: params.toDate)
                .setBody(key: .pageIndex, value: "\(params.pageIndex)")
                .setBody(key: .providerType, value: "\(params.providerType)")
                .setBody(key: .maxResult, value: "\(CoreApiTransactionHistoryRepository.maxResult)")

            if let transactionType = params.transactionType {
                requestBuilder = requestBuilder
                    .setBody(key: .transactionType, value: "\(transactionType)")
            }

            return requestBuilder
        }
    }
}
