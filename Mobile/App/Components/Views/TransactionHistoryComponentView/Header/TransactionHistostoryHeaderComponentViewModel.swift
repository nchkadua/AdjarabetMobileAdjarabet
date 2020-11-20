//
//  TransactionHistostoryHeaderComponentViewModel.swift
//  Mobile
//
//  Created by Irakli Shelia on 11/17/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public protocol TransactionHistoryHeaderComponentViewModel: TransactionHistostoryHeaderComponentViewModelInput,
                                                               TransactionHistostoryHeaderComponentViewModelOutput {}

public struct TransactionHistostoryHeaderComponentViewModelParams {
    public var title: String
}

public protocol TransactionHistostoryHeaderComponentViewModelInput {
    func didBind()
}

public protocol TransactionHistostoryHeaderComponentViewModelOutput {
    var action: Observable<TransactionHistostoryHeaderComponentViewModelOutputAction> { get }
    var params: TransactionHistostoryHeaderComponentViewModelParams { get }
}

public enum TransactionHistostoryHeaderComponentViewModelOutputAction {
    case set(title: String)
}

public class DefaultTransactionHistostoryHeaderComponentViewModel {
    public var params: TransactionHistostoryHeaderComponentViewModelParams
    private let actionSubject = PublishSubject<TransactionHistostoryHeaderComponentViewModelOutputAction>()
    public init(params: TransactionHistostoryHeaderComponentViewModelParams) {
        self.params = params
    }
}

extension DefaultTransactionHistostoryHeaderComponentViewModel: TransactionHistoryHeaderComponentViewModel {
    public var action: Observable<TransactionHistostoryHeaderComponentViewModelOutputAction> {
        actionSubject.asObserver()
    }

    public func didBind() {
        actionSubject.onNext(.set(title: params.title))
    }
}
