//
//  TransactionDetailComponentViewModel.swift
//  Mobile
//
//  Created by Irakli Shelia on 11/18/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public protocol TransactionDetailsComponentViewModel: TransactionDetailsComponentViewModelInput,
                                                     TransactionDetailsComponentViewModelOutput {}

public struct TransactionDetailsComponentViewModelParams {
    public let title: String
    public let description: String
}

public protocol TransactionDetailsComponentViewModelInput {
    func didBind()
}

public protocol TransactionDetailsComponentViewModelOutput {
    var action: Observable<TransactionDetailsComponentViewModelOutputAction> { get }
    var params: TransactionDetailsComponentViewModelParams { get }
}

public enum TransactionDetailsComponentViewModelOutputAction {
    case set(title: String, description: String)
}

public class DefaultTransactionDetailsComponentViewModel {
    public var params: TransactionDetailsComponentViewModelParams
    private let actionSubject = PublishSubject<TransactionDetailsComponentViewModelOutputAction>()
    public init(params: TransactionDetailsComponentViewModelParams) {
        self.params = params
    }
}

extension DefaultTransactionDetailsComponentViewModel: TransactionDetailsComponentViewModel {
    public var action: Observable<TransactionDetailsComponentViewModelOutputAction> {
        actionSubject.asObserver()
    }
    
    public func didBind() {
        actionSubject.onNext(.set(title: params.title, description: params.description))
    }
}
