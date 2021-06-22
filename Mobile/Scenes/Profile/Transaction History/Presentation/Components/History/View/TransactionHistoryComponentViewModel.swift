//
//  TransactionHistoryComponentViewModel.swift
//  Mobile
//
//  Created by Irakli Shelia on 11/17/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public protocol TransactionHistoryComponentViewModel: TransactionHistoryComponentViewModelInput,
                                                      TransactionHistoryComponentViewModelOutput {
}

public struct TransactionHistoryComponentViewModelParams {
    public let transactionHistory: TransactionHistory
}

public protocol TransactionHistoryComponentViewModelInput {
    func didBind()
    func didSelect(at indexPath: IndexPath)
}

public protocol TransactionHistoryComponentViewModelOutput {
    var action: Observable<TransactionHistoryComponentViewModelOutputAction> { get }
    var params: TransactionHistoryComponentViewModelParams { get }
}

public enum TransactionHistoryComponentViewModelOutputAction {
    case set(transactionHistory: TransactionHistory)
    case didSelect(transactionHistory: TransactionHistory)
}

public class DefaultTransactionHistoryComponentViewModel {
    public let params: TransactionHistoryComponentViewModelParams
    private let actionSubject = PublishSubject<TransactionHistoryComponentViewModelOutputAction>()
    public init(params: TransactionHistoryComponentViewModelParams) {
        self.params = params
    }
}

extension DefaultTransactionHistoryComponentViewModel: TransactionHistoryComponentViewModel {
    public func didSelect(at indexPath: IndexPath) {
        actionSubject.onNext(.didSelect(transactionHistory: params.transactionHistory))
    }

    public var action: Observable<TransactionHistoryComponentViewModelOutputAction> {
        actionSubject.asObserver()
    }
    public func didBind() {
        actionSubject.onNext(.set(transactionHistory: params.transactionHistory))
    }
}
