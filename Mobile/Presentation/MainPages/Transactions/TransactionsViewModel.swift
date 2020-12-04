//
//  TransactionsViewModel.swift
//  Mobile
//
//  Created by Irakli Shelia on 11/16/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public protocol TransactionsViewModel: TransactionsViewModelInput, TransactionsViewModelOutput, ABTableViewControllerDelegate {
}

public protocol TransactionsViewModelInput {
    func viewDidLoad()
    func calendarTabItemClicked()
}

public protocol TransactionsViewModelOutput {
    var action: Observable<TransactionsViewModelOutputAction> { get }
    var route: Observable<TransactionsViewModelRoute> { get }
}

public enum TransactionsViewModelOutputAction {
    case languageDidChange
    case initialize(AppListDataProvider)
    case reloadItems(items: AppCellDataProviders, insertionIndexPathes: [IndexPath], deletionIndexPathes: [IndexPath])
}

public enum TransactionsViewModelRoute {
    case openTransactionDetails(transactionHistory: TransactionHistory)
    case openTransactionFilter(params: TransactionsFilterViewModelParams)
}

public class DefaultTransactionsViewModel: DefaultBaseViewModel {
    private let actionSubject = PublishSubject<TransactionsViewModelOutputAction>()
    private let routeSubject = PublishSubject<TransactionsViewModelRoute>()
    @Inject(from: .useCases) private var displayTransactionsUseCase: DisplayTransactionHistoriesUseCase
    private var page: PageDescription = .init()
    private var transactionsDataProvider: AppCellDataProviders = []
    private var filteredParams: DisplayTransactionHistoriesUseCaseParams?
    public override func languageDidChange() {
        actionSubject.onNext(.languageDidChange)
    }
}

extension DefaultTransactionsViewModel: TransactionsViewModel {
    public var action: Observable<TransactionsViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<TransactionsViewModelRoute> { routeSubject.asObserver() }

    // MARK: TransactionsViewModelInput

    public func viewDidLoad() {
        displayEmptyTransactionList()
        displayUnfilteredTransactions()
    }

    public func calendarTabItemClicked() {
        let params = TransactionsFilterViewModelParams()
        subscribeToTransactionsFilterViewModelParams(params)
        routeSubject.onNext(.openTransactionFilter(params: params))
    }

    // MARK: Display transctions methods

    private func displayEmptyTransactionList() {
        self.resetPaging()
        let initialEmptyDataProvider: AppCellDataProviders = []
        self.actionSubject.onNext(.initialize(initialEmptyDataProvider.makeList()))
    }

    private func displayUnfilteredTransactions() {
        let fromDate = TransactionHistoryEntity.dateFormatter.string(from: Date.distantPast)
        let toDate = TransactionHistoryEntity.dateFormatter.string(from: Date.distantFuture)
        let params: DisplayTransactionHistoriesUseCaseParams = .init(fromDate: fromDate,
                                                                     toDate: toDate,
                                                                     transactionType: TransactionType.all.rawValue, // all transactions
                                                                     providerType: ProviderType.transactions.rawValue,
                                                                     pageIndex: page.current)
        displayTransactions(params: params)
    }

    private func displayFilteredTransactions(params: DisplayTransactionHistoriesUseCaseParams) {
        var updatedPageFilteredParams = params
        updatedPageFilteredParams.pageIndex = page.current
        displayTransactions(params: updatedPageFilteredParams)
    }

    private func constructFilteredTransactionParams(fromDate: Date?, toDate: Date?, providerType: ProviderType, transactionType: TransactionType) {
        let fromDateString = TransactionHistoryEntity.dateFormatter.string(from: fromDate ?? Date.distantPast)
        let toDateString = TransactionHistoryEntity.dateFormatter.string(from: toDate ?? Date.distantFuture)

        let params: DisplayTransactionHistoriesUseCaseParams = .init(fromDate: fromDateString,
                                                                     toDate: toDateString,
                                                                     transactionType: transactionType.rawValue, // all transactions
                                                                     providerType: providerType.rawValue,
                                                                     pageIndex: page.current)
        self.filteredParams = params
    }

    private func displayTransactions(params: DisplayTransactionHistoriesUseCaseParams) {
        displayTransactionsUseCase.execute(params: params) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let transactions):
                var datesSet: Set<Date>  = []
                var viewModels: AppCellDataProviders = []
                transactions.forEach { transaction in
                    let transactionDetails = self.constructTransactionDetails(from: transaction)
                    let componentViewModel = self.consturctTransactionHistoryComponentViewModel(from: transaction, with: transactionDetails)
                    self.subscribeToTransactionComponent(componentViewModel)
                    if let transactionDate = transaction.date {
                        if !datesSet.contains(transactionDate) {
                            datesSet.insert(transactionDate)
                            let headerViewModel = self.constructTransactionHistoryHeader(from: transaction)
                            viewModels.append(headerViewModel)
                        }
                    }
                    viewModels.append(componentViewModel)
                }
                self.appendPage(transactions: viewModels)
            case .failure(let error):
                self.displayEmptyTransactionList()
                print(error)
            }
        }
    }

    // MARK: Paging

    private func appendPage(transactions: AppCellDataProviders) {
        let offset = self.transactionsDataProvider.count
        self.page.setNextPage()
        self.page.configureHasMore(forNumberOfItems: transactions.count)

        self.transactionsDataProvider.append(contentsOf: transactions)

        let indexPathes = transactions.enumerated().map { IndexPath(item: offset + $0.offset, section: 0) }
        actionSubject.onNext(.reloadItems(items: transactions, insertionIndexPathes: indexPathes, deletionIndexPathes: []))
    }

    private func resetPaging() {
        self.transactionsDataProvider = []
        page.reset()
        page.itemsPerPage = 10
        page.current = 0
    }

    // MARK: ABTableViewControllerDelegate

    public func didDeleteCell(at indexPath: IndexPath) { }

    public func didLoadNextPage() {
        guard page.hasMore else { return }
        if let filteredParams = self.filteredParams {
            displayFilteredTransactions(params: filteredParams)
        } else {
            displayUnfilteredTransactions()
        }
    }

    // MARK: Subscriptions to components

    private func subscribeToTransactionsFilterViewModelParams(_ params: TransactionsFilterViewModelParams) {
        params.paramsOutputAction.subscribe(onNext: {[weak self] action in
            guard let self = self else { return }
            switch action {
            case .filterSelected(let fromDate, let toDate, let providerType, let transactionType):
                self.displayEmptyTransactionList()
                self.constructFilteredTransactionParams(fromDate: fromDate,
                                                        toDate: toDate,
                                                        providerType: providerType,
                                                        transactionType: transactionType)
                self.displayFilteredTransactions(params: self.filteredParams!)
            }
        })
        .disposed(by: self.disposeBag)
    }

    private func subscribeToTransactionComponent(_ viewModel: DefaultTransactionHistoryComponentViewModel) {
        viewModel.action.subscribe(onNext: { action in
            switch action {
            case .didSelect(let transactionHistory):
                self.routeSubject.onNext(.openTransactionDetails(transactionHistory: transactionHistory))
            default:
                break
            }
        }).disposed(by: self.disposeBag)
    }

    // MARK: Component View Model Setups

    private func constructTransactionHistoryHeader(from entity: TransactionHistoryEntity) -> DefaultTransactionHistostoryHeaderComponentViewModel {
        let stringDate = TransactionHistoryEntity.dateFormatter.string(from: entity.date!)
        let headerModel = DefaultTransactionHistostoryHeaderComponentViewModel(params: .init(title: stringDate))
        return headerModel
    }

    private func constructTransactionDetails(from entity: TransactionHistoryEntity) -> [TransactionDetail] {
        var transactionDetails: [TransactionDetail] = []
        if let totalAmount = entity.totalAmount {
            transactionDetails.append(TransactionDetail(title: "ჯამური თანხა", description: String(totalAmount)))
        }
        if let date = entity.date {
            transactionDetails.append(TransactionDetail(title: "დრო", description: TransactionHistoryEntity.dateFormatter.string(from: date)))
        }
        if let feeAmount = entity.feeAmount {
            transactionDetails.append(TransactionDetail(title: "ტრანზაქციის საკომისიო", description: String(feeAmount)))
        }
        //        transactionDetails.append(TransactionDetail(title: "გადახდის ტიპი", description: entity.feeAmount )) TODO

        return transactionDetails
    }

    private func consturctTransactionHistoryComponentViewModel(from entity: TransactionHistoryEntity, with details: [TransactionDetail]) -> DefaultTransactionHistoryComponentViewModel {
        let transactionHistory = TransactionHistory(title: entity.providerName ?? "",
                                                    subtitle: "შემოტანა",
                                                    amount: String(entity.totalAmount ?? 0),
                                                    icon: R.image.transactionsHistory.deposit()!,
                                                    details: details)
        let componentViewModel = DefaultTransactionHistoryComponentViewModel(params: .init(transactionHistory: transactionHistory))
        return componentViewModel
    }
}
