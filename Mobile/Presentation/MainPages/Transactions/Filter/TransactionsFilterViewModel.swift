//
//  TransactionsFilterViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 11/26/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public protocol TransactionsFilterViewModel: TransactionsFilterViewModelInput, TransactionsFilterViewModelOutput {
}

public enum FilterType {
    case transactions
    case games
}

public protocol TransactionsFilterViewModelInput {
    func viewDidLoad()
    func onClick(type: FilterType)
}

public protocol TransactionsFilterViewModelOutput {
    var action: Observable<TransactionsFilterViewModelOutputAction> { get }
    var route: Observable<TransactionsFilterViewModelRoute> { get }
}

public enum TransactionsFilterViewModelOutputAction {
    case languageDidChange
    case initialize(AppListDataProvider)
    case selectFilter(filter: FilterType)
}

public enum TransactionsFilterViewModelRoute {
}

public class DefaultTransactionsFilterViewModel {
    private let actionSubject = PublishSubject<TransactionsFilterViewModelOutputAction>()
    private let routeSubject = PublishSubject<TransactionsFilterViewModelRoute>()
    private var selectedFilterType: FilterType = .transactions
    
}

extension DefaultTransactionsFilterViewModel: TransactionsFilterViewModel {
    public func onClick(type: FilterType) {
        guard type != selectedFilterType else { return }
        
        if selectedFilterType == .transactions {
                actionSubject.onNext(.selectFilter(filter: .games))
        } else if selectedFilterType == .games {
                actionSubject.onNext(.selectFilter(filter: .transactions))
        }
        selectedFilterType = type
    }

    public var action: Observable<TransactionsFilterViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<TransactionsFilterViewModelRoute> { routeSubject.asObserver() }
        
    public func viewDidLoad() {
        var dataProvider: AppCellDataProviders = []
        TransactionFilters.filters.forEach {
            let viewModel = DefaultTransactionFilterComponentViewModel(params: .init(title: $0.title, checked: $0.checked))
            dataProvider.append(viewModel)
        }
        actionSubject.onNext(.initialize(dataProvider.makeList()))
        actionSubject.onNext(.selectFilter(filter: .transactions))
    }
}
