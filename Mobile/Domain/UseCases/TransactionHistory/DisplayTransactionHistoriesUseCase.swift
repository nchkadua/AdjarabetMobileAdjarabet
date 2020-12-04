//
//  DisplayTransactionHistoriesUseCase.swift
//  Mobile
//
//  Created by Irakli Shelia on 11/30/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

public protocol DisplayTransactionHistoriesUseCase {
    typealias DisplayTransactionHistoriesUseCaseCompletionHandler = (Result<[TransactionHistoryEntity], Error>) -> Void
    @discardableResult
    func execute(params: DisplayTransactionHistoriesUseCaseParams,
                 completion: @escaping DisplayTransactionHistoriesUseCaseCompletionHandler) -> Cancellable?
}

public final class DefaultDisplayTransactionHistoriesUseCase: DisplayTransactionHistoriesUseCase {
    @Inject(from: .repositories) private var transactionHistoryRepository: TransactionHistoryRepository
    @Inject private var userSession: UserSessionReadableServices

    public func execute(params: DisplayTransactionHistoriesUseCaseParams, completion: @escaping DisplayTransactionHistoriesUseCaseCompletionHandler) -> Cancellable? {
        let requestParams: GetUserTransactionsParams = .init(fromDate: params.fromDate,
                                                             toDate: params.toDate,
                                                             transactionType: params.transactionType,
                                                             providerType: params.providerType,
                                                             pageIndex: params.pageIndex)

        transactionHistoryRepository.getUserTransactions(params: requestParams) { result  in
            switch result {
            case .success(let transactionHistories):
                completion(.success(transactionHistories))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        return nil // TODO??
    }
}

public struct DisplayTransactionHistoriesUseCaseParams {
    let fromDate: String
    let toDate: String
    let transactionType: Int
    let providerType: Int
    var pageIndex: Int
}
