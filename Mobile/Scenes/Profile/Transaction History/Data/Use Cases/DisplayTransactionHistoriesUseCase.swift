//
//  DisplayTransactionHistoriesUseCase.swift
//  Mobile
//
//  Created by Irakli Shelia on 11/30/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

protocol DisplayTransactionHistoriesUseCase {
    typealias DisplayTransactionHistoriesUseCaseCompletionHandler = (Result<[TransactionHistoryEntity], ABError>) -> Void
    func execute(params: DisplayTransactionHistoriesUseCaseParams,
                 completion: @escaping DisplayTransactionHistoriesUseCaseCompletionHandler)
}

class DefaultDisplayTransactionHistoriesUseCase: DisplayTransactionHistoriesUseCase {
    @Inject(from: .repositories) private var transactionHistoryRepository: TransactionHistoryRepository
    private let dayDateFormatter = ABDateFormater(with: .day)

    func execute(params: DisplayTransactionHistoriesUseCaseParams,
                 completion: @escaping DisplayTransactionHistoriesUseCaseCompletionHandler) {
        // Date Selection in UI is inclusive
        // Date selection in API is exclusive
        // We need to add 1 day to to include desired last day
        let endDate = dayDateFormatter.date(from: params.toDate)
        let correctEndDate = Calendar.current.date(byAdding: .day, value: 1, to: endDate!)!
        let correctEndDateString = dayDateFormatter.string(from: correctEndDate)

        let requestParams: GetUserTransactionsParams = .init(fromDate: params.fromDate,
                                                             toDate: correctEndDateString,
                                                             transactionType: params.transactionType,
                                                             providerType: params.providerType,
                                                             pageIndex: params.pageIndex)

        transactionHistoryRepository.getUserTransactions(params: requestParams, completion: completion)
    }
}

struct DisplayTransactionHistoriesUseCaseParams {
    let fromDate: String
    let toDate: String
    let transactionType: Int?
    let providerType: Int
    var pageIndex: Int
}
