//
//  TransactionFilterComponentViewModel.swift
//  Mobile
//
//  Created by Irakli Shelia on 11/27/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public protocol TransactionFilterComponentViewModel: TransactionFilterComponentViewModelInput,
                                                TransactionFilterComponentViewModelOutput {}

public struct TransactionFilterComponentViewModelParams {
    public let title: String
    public let checked: Bool
}

public protocol TransactionFilterComponentViewModelInput {
    func didBind()
}

public protocol TransactionFilterComponentViewModelOutput {
    var action: Observable<TransactionFilterComponentViewModelOutputAction> { get }
    var params: TransactionFilterComponentViewModelParams { get }
}

public enum TransactionFilterComponentViewModelOutputAction {
    case set(title: String, checked: Bool)
}

public class DefaultTransactionFilterComponentViewModel {
    public var params: TransactionFilterComponentViewModelParams
    private let actionSubject = PublishSubject<TransactionFilterComponentViewModelOutputAction>()
    public init(params: TransactionFilterComponentViewModelParams) {
        self.params = params
    }
}

extension DefaultTransactionFilterComponentViewModel: TransactionFilterComponentViewModel {
    public var action: Observable<TransactionFilterComponentViewModelOutputAction> {
        actionSubject.asObserver()
    }

    public func didBind() {
        actionSubject.onNext(.set(title: params.title, checked: params.checked))
    }
}
