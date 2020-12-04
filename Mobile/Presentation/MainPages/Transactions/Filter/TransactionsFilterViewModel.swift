//
//  TransactionsFilterViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 11/26/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public protocol TransactionsFilterViewModel: TransactionsFilterViewModelInput, TransactionsFilterViewModelOutput {}

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
}

public protocol TransactionsFilterViewModelInput: AnyObject {
    var params: TransactionsFilterViewModelParams? { get set }
    func viewDidLoad()
    func onClick(type: ProviderType)
    func setupTransactionTypeList()
    func saveFilterClicked()
    func filterSelected(fromDate: Date, toDate: Date)
}

public protocol TransactionsFilterViewModelOutput {
    var action: Observable<TransactionsFilterViewModelOutputAction> { get }
    var route: Observable<TransactionsFilterViewModelRoute> { get }
}

public enum TransactionsFilterViewModelOutputAction {
    case languageDidChange
    case initialize(AppListDataProvider)
    case providerTypeSelected(provider: ProviderType)
    case bindToCalendarComponentViewModel(viewmodel: CalendarComponentViewModel)
    case transactionTypeToggled
}

public enum TransactionsFilterViewModelRoute {
}

public class DefaultTransactionsFilterViewModel: DefaultBaseViewModel {
    private let actionSubject = PublishSubject<TransactionsFilterViewModelOutputAction>()
    private let routeSubject = PublishSubject<TransactionsFilterViewModelRoute>()
    private var selectedProviderType: ProviderType = .transactions
    private var transactionTypeManager = TransactionTypeManager()
    public var params: TransactionsFilterViewModelParams?
    private var fromDate: Date?
    private var toDate: Date?
    @Inject(from: .componentViewModels) private var calendarComponentViewModel: CalendarComponentViewModel
}

extension DefaultTransactionsFilterViewModel: TransactionsFilterViewModel {
    public var action: Observable<TransactionsFilterViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<TransactionsFilterViewModelRoute> { routeSubject.asObserver() }
    public func viewDidLoad() {
        actionSubject.onNext(.providerTypeSelected(provider: .transactions))
        actionSubject.onNext(.bindToCalendarComponentViewModel(viewmodel: calendarComponentViewModel))
    }

    public func saveFilterClicked() {
        guard let params = params else { return }
        params.paramsOutputAction.onNext(.filterSelected(fromDate: self.fromDate, toDate: self.toDate,
                                                         providerType: selectedProviderType,
                                                         transactionType: transactionTypeManager.selectedTransactionType ?? .all))
    }

    public func onClick(type: ProviderType) {
        guard type != selectedProviderType else { return }

        if selectedProviderType == .transactions {
            actionSubject.onNext(.providerTypeSelected(provider: .games))
        } else if selectedProviderType == .games {
            actionSubject.onNext(.providerTypeSelected(provider: .transactions))
        }
        selectedProviderType = type
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
        self.fromDate = fromDate
        self.toDate = toDate
    }
}
