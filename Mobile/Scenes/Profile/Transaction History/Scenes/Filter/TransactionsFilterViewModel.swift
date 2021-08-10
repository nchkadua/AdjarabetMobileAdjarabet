//
//  TransactionsFilterViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 11/26/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

protocol TransactionsFilterViewModel: BaseViewModel, TransactionsFilterViewModelInput, TransactionsFilterViewModelOutput {}

// Move somewhere logical
public enum ProviderType: Int {
    case games = 0
    case transactions = 1
    case system = 2
}

public struct TransactionsFilterViewModelParams {
    public enum Action {
        case filterSelected(fromDate: Date?, toDate: Date?, providerType: ProviderType, transactionType: TransactionType)
    }
    public let paramsOutputAction = PublishSubject<Action>()
    var selectedProviderType: ProviderType = .transactions
    var selectedTransactionType: TransactionType = .all
    var fromDate: Date?
    var toDate: Date?
}

public protocol TransactionsFilterViewModelInput: AnyObject {
    var params: TransactionsFilterViewModelParams! { get set }
    func viewDidLoad()
    func onClick(type: ProviderType)
    func setupTransactionTypeList()
    func saveFilterClicked()
    func filterSelected(fromDate: Date, toDate: Date)
    func didSetupCalendar()
}

public protocol TransactionsFilterViewModelOutput {
    var action: Observable<TransactionsFilterViewModelOutputAction> { get }
    var route: Observable<TransactionsFilterViewModelRoute> { get }
}

public enum TransactionsFilterViewModelOutputAction {
    case languageDidChange
    case initialize(AppListDataProvider)
    case providerTypeSelected(provider: ProviderType)
    case transactionTypeToggled
    case selectDateRange(fromDate: Date, toDate: Date)
}

public enum TransactionsFilterViewModelRoute {
}

public class DefaultTransactionsFilterViewModel: DefaultBaseViewModel {
    private let actionSubject = PublishSubject<TransactionsFilterViewModelOutputAction>()
    private let routeSubject = PublishSubject<TransactionsFilterViewModelRoute>()
    private var transactionTypeManager = TransactionTypeManager()
    public var params: TransactionsFilterViewModelParams!
}

extension DefaultTransactionsFilterViewModel: TransactionsFilterViewModel {
    public var action: Observable<TransactionsFilterViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<TransactionsFilterViewModelRoute> { routeSubject.asObserver() }
    public func viewDidLoad() {
    }

    public func saveFilterClicked() {
        params.paramsOutputAction.onNext(.filterSelected(fromDate: params.fromDate, toDate: params.toDate,
                                                         providerType: params.selectedProviderType,
                                                         transactionType: params.selectedTransactionType))
    }

    public func onClick(type: ProviderType) {
        guard type != params.selectedProviderType else { return }

        if params.selectedProviderType == .transactions {
            actionSubject.onNext(.providerTypeSelected(provider: .games))
        } else if params.selectedProviderType == .games {
            actionSubject.onNext(.providerTypeSelected(provider: .transactions))
        }
        params.selectedProviderType = type
    }

    public func setupTransactionTypeList() {
        var dataProvider: AppCellDataProviders = []
        transactionTypeManager.dataSource.forEach {
            let viewModel = DefaultTransactionFilterComponentViewModel(params: .init(title: $0.title,
                                                                                     checked: $0.checked,
                                                                                     transactionType: $0.transactionType))
            viewModel.action.subscribe(onNext: { [weak self] action in
                guard let self = self else { return }
                switch action {
                case .checkBoxToggled(let state):
                    self.transactionTypeManager.setTransaction(type: viewModel.params.transactionType, to: state)
                    self.params.selectedTransactionType = self.transactionTypeManager.selectedTransactionType ?? .all
                    self.actionSubject.onNext(.transactionTypeToggled)
                default:
                    break
                }
            }).disposed(by: self.disposeBag)
            dataProvider.append(viewModel)
        }
        actionSubject.onNext(.initialize(dataProvider.makeList()))
    }

    public func filterSelected(fromDate: Date, toDate: Date) {
        params.fromDate = fromDate
        params.toDate = toDate
    }

    public func didSetupCalendar() {
        self.transactionTypeManager.setTransaction(type: params.selectedTransactionType, to: true)
        actionSubject.onNext(.providerTypeSelected(provider: params.selectedProviderType))
        if params.fromDate != nil && params.toDate != nil {
            actionSubject.onNext(.selectDateRange(fromDate: params.fromDate!, toDate: params.toDate!))
        }
    }
}
