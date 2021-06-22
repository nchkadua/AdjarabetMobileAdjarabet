//
//  TransactionHistory.swift
//  Mobile
//
//  Created by Irakli Shelia on 11/30/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

// MARK: Repository
protocol TransactionHistoryRepository: TransactionHistoryRedableRepository,
                                       TransactionHistoryWritableRepository { }

// MARK: - Readable Repository
protocol TransactionHistoryRedableRepository {
    typealias GetUserTransactionsCompletionHandler = (Result<[TransactionHistoryEntity], ABError>) -> Void
    func getUserTransactions(params: GetUserTransactionsParams, completion: @escaping GetUserTransactionsCompletionHandler)
}

public struct GetUserTransactionsParams {
    let fromDate: String
    let toDate: String
    let transactionType: Int?
    let providerType: Int
    let pageIndex: Int
}

// MARK: - Writable Repository
public protocol TransactionHistoryWritableRepository {
}
