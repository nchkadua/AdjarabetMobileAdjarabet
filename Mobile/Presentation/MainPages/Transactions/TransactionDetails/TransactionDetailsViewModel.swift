//
//  TransactionDetailsViewModel.swift
//  Mobile
//
//  Created by Irakli Shelia on 11/19/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public protocol TransactionDetailsViewModel: TransactionDetailsViewModelInput, TransactionDetailsViewModelOutput {
}

public struct TransactionDetailsViewModelParams {
    public let transactionHistory: TransactionHistory
}

public protocol TransactionDetailsViewModelInput {
    func viewDidLoad()
}

public protocol TransactionDetailsViewModelOutput {
    var action: Observable<TransactionDetailsViewModelOutputAction> { get }
    var route: Observable<TransactionDetailsViewModelRoute> { get }
    var params: TransactionDetailsViewModelParams { get }
}

public enum TransactionDetailsViewModelOutputAction {
    case languageDidChange
    case initialize(AppListDataProvider)
}

public enum TransactionDetailsViewModelRoute {
}

public class DefaultTransactionDetailsViewModel: DefaultBaseViewModel {
    private let actionSubject = PublishSubject<TransactionDetailsViewModelOutputAction>()
    private let routeSubject = PublishSubject<TransactionDetailsViewModelRoute>()
    public let params: TransactionDetailsViewModelParams
    
    public init(params: TransactionDetailsViewModelParams) {
        self.params = params
    }
    
    public override func languageDidChange() {
        actionSubject.onNext(.languageDidChange)
    }
}

extension DefaultTransactionDetailsViewModel: TransactionDetailsViewModel {
    public var action: Observable<TransactionDetailsViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<TransactionDetailsViewModelRoute> { routeSubject.asObserver() }
    
    public func viewDidLoad() {
        
        var dataProvider: AppCellDataProviders = []
        params.transactionHistory.details.forEach {
            let model = DefaultTransactionDetailsComponentViewModel(params: .init(title: $0.title, description: $0.description))
            dataProvider.append(model)
        }
        actionSubject.onNext(.initialize(dataProvider.makeList()))
    }
}
