//
//  TransactionsViewModel.swift
//  Mobile
//
//  Created by Irakli Shelia on 11/16/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public protocol TransactionsViewModel: TransactionsViewModelInput, TransactionsViewModelOutput {
}

public protocol TransactionsViewModelInput {
    func viewDidLoad()
}

public protocol TransactionsViewModelOutput {
    var action: Observable<TransactionsViewModelOutputAction> { get }
    var route: Observable<TransactionsViewModelRoute> { get }
}

public enum TransactionsViewModelOutputAction {
    case languageDidChange
    case initialize(AppListDataProvider)
}

public enum TransactionsViewModelRoute {
    case openTransactionDetails(transactionHistory: TransactionHistory)
}

public class DefaultTransactionsViewModel: DefaultBaseViewModel {
    private let actionSubject = PublishSubject<TransactionsViewModelOutputAction>()
    private let routeSubject = PublishSubject<TransactionsViewModelRoute>()
    public override func languageDidChange() {
        actionSubject.onNext(.languageDidChange)
    }
}

extension DefaultTransactionsViewModel: TransactionsViewModel {
    public var action: Observable<TransactionsViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<TransactionsViewModelRoute> { routeSubject.asObserver() }
    public func viewDidLoad() {
        var dataProvider: AppCellDataProviders = []
        TransactionHistoryProvider.MockTransactionHeaders.forEach {
            let headerModel = DefaultTransactionHistostoryHeaderComponentViewModel(params: .init(title: $0.title))
            dataProvider.append(headerModel)

            TransactionHistoryProvider.MockTransactions.forEach {
                let model = DefaultTransactionHistoryComponentViewModel(params: .init(transactionHistory: $0))
                model.action.subscribe(onNext: { action in
                    switch action {
                    case .didSelect(let transactionHistory):
                        self.routeSubject.onNext(.openTransactionDetails(transactionHistory: transactionHistory))
                    default:
                        break
                    }
                }).disposed(by: disposeBag)
                dataProvider.append(model)
            }
        }

        actionSubject.onNext(.initialize(dataProvider.makeList()))
    }
}
