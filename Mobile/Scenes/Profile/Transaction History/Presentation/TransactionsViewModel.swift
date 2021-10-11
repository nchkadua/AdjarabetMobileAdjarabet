//
//  TransactionsViewModel.swift
//  Mobile
//
//  Created by Irakli Shelia on 11/16/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

protocol TransactionsViewModel: BaseViewModel,
                                TransactionsViewModelInput,
                                TransactionsViewModelOutput,
                                ABTableViewControllerDelegate {}

protocol TransactionsViewModelInput: AnyObject {
    func viewDidLoad()
    func calendarTabItemClicked()

    var emptyStateViewModel: EmptyStateComponentViewModel { get }
}

protocol TransactionsViewModelOutput {
    var action: Observable<TransactionsViewModelOutputAction> { get }
    var route: Observable<TransactionsViewModelRoute> { get }
}

enum TransactionsViewModelOutputAction {
    case languageDidChange
    case initialize(AppListDataProvider)
    case reloadItems(items: AppCellDataProviders, insertionIndexPathes: [IndexPath], deletionIndexPathes: [IndexPath])
    case isLoading(loading: Bool)
}

enum TransactionsViewModelRoute {
    case openTransactionDetails(transactionHistory: TransactionHistory)
    case openTransactionFilter(params: TransactionsFilterViewModelParams)
}

class DefaultTransactionsViewModel: DefaultBaseViewModel {
    private let actionSubject = PublishSubject<TransactionsViewModelOutputAction>()
    private let routeSubject = PublishSubject<TransactionsViewModelRoute>()
    public lazy var emptyStateViewModel: EmptyStateComponentViewModel =
		DefaultEmptyStateComponentViewModel(params: .init(
												icon: R.image.transactionsHistory.empty_state_icon()!,
												title: R.string.localization.transactions_empty_state_title(),
												description: R.string.localization.transactions_empty_state_description()))

    @Inject(from: .useCases) private var displayTransactionsUseCase: DisplayTransactionHistoriesUseCase
    @Inject(from: .useCases) private var amountFormatter: AmountFormatterUseCase

    // State
    private var page: PageDescription = .init()
    private var filteredParams: DisplayTransactionHistoriesUseCaseParams?
    private var transactionsDataProvider: AppCellDataProviders = []

    private let dayDateFormatter = ABDateFormater(with: .day)
    private let hourDateFormatter = ABDateFormater(with: .hour)

    private var uniqueHeaderDatesSet: Set<String>  = []
    override func languageDidChange() {
        actionSubject.onNext(.languageDidChange)
    }
}

extension DefaultTransactionsViewModel: TransactionsViewModel {
    var action: Observable<TransactionsViewModelOutputAction> { actionSubject.asObserver() }
    var route: Observable<TransactionsViewModelRoute> { routeSubject.asObserver() }

    // MARK: TransactionsViewModelInput

    func viewDidLoad() {
        displayEmptyTransactionList()
        displayUnfilteredTransactions()
    }

    func calendarTabItemClicked() {
        var params = TransactionsFilterViewModelParams()
        if let filteredParams = filteredParams {
            params.fromDate = dayDateFormatter.date(from: filteredParams.fromDate)
            params.toDate = dayDateFormatter.date(from: filteredParams.toDate)
            params.selectedTransactionType = TransactionType(rawValue: filteredParams.transactionType ?? 0)!
            params.selectedProviderType = ProviderType(rawValue: filteredParams.providerType)!
        }
        subscribeToTransactionsFilterViewModelParams(params)
        routeSubject.onNext(.openTransactionFilter(params: params))
    }

    // MARK: Display transctions methods

    private func displayEmptyTransactionList() {
        resetPaging()
        uniqueHeaderDatesSet.removeAll()
        let initialEmptyDataProvider: AppCellDataProviders = []
        actionSubject.onNext(.initialize(initialEmptyDataProvider.makeList()))
    }

    private func displayUnfilteredTransactions() {
        let fromDate = dayDateFormatter.string(from: Date.distantPast)
        let toDate = dayDateFormatter.string(from: Date.distantFuture)
        let params: DisplayTransactionHistoriesUseCaseParams = .init(fromDate: fromDate,
                                                                     toDate: toDate,
                                                                     transactionType: nil, // all transactions
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
        let trType = transactionType.rawValue == 0 ? nil : transactionType.rawValue
        let fromDate = dayDateFormatter.string(from: fromDate ?? Date.distantPast)
        let toDate = dayDateFormatter.string(from: toDate ?? Date.distantFuture)
        let params: DisplayTransactionHistoriesUseCaseParams = .init(fromDate: fromDate,
                                                                     toDate: toDate,
                                                                     transactionType: trType,
                                                                     providerType: providerType.rawValue,
                                                                     pageIndex: page.current)
        self.filteredParams = params
    }

    private func displayTransactions(params: DisplayTransactionHistoriesUseCaseParams) {
        actionSubject.onNext(.isLoading(loading: true))
        displayTransactionsUseCase.execute(params: params) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let transactions):
                var viewModels: AppCellDataProviders = []
                transactions.forEach { transaction in
                    let transactionDetails = self.constructTransactionDetails(from: transaction)
                    let componentViewModel = self.consturctTransactionHistoryComponentViewModel(from: transaction, with: transactionDetails)
                    self.subscribeToTransactionComponent(componentViewModel)
                    let dateDayString = self.dayDateFormatter.string(from: transaction.date)
                    if !self.uniqueHeaderDatesSet.contains(dateDayString) {
                        self.uniqueHeaderDatesSet.insert(dateDayString)
                        let headerViewModel = self.constructTransactionHistoryHeader(from: transaction)
                        viewModels.append(headerViewModel)
                    }
                    viewModels.append(componentViewModel)
                }
                self.appendPage(transactions: viewModels)
            case .failure(let error):
                self.displayEmptyTransactionList()
                self.show(error: error)
            }
            self.actionSubject.onNext(.isLoading(loading: false))
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
    // Unused delegate methods
    public func didDeleteCell(at indexPath: IndexPath) { }
    public func redraw(at indexPath: IndexPath) { }

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

    private func constructTransactionHistoryHeader(from entity: TransactionHistoryEntity) -> DefaultDateHeaderComponentViewModel {
        let stringDate = dayDateFormatter.string(from: entity.date)
        let headerModel = DefaultDateHeaderComponentViewModel(params: .init(title: stringDate, showSeparator: false))
        return headerModel
    }

    private func constructTransactionDetails(from entity: TransactionHistoryEntity) -> [TransactionDetail] {
        var totalAndFee = 0.0
        var transactionDetails: [TransactionDetail] = []
        let transactionType: TransactionType = entity.totalAmount < 0 ? .withdraw : .deposit

        transactionDetails.append(TransactionDetail(title: R.string.localization.transactions_details_date(),
                                                    description: hourDateFormatter.string(from: entity.date)))

        if transactionType == .deposit {
            totalAndFee = entity.totalAmount + entity.feeAmount
        } else if transactionType == .withdraw {
            totalAndFee = entity.totalAmount - entity.feeAmount
        }

        transactionDetails.append(TransactionDetail(title: R.string.localization.transactions_details_total_amount(),
                                                    description: prettyAmount(from: totalAndFee)))

        transactionDetails.append(TransactionDetail(title: R.string.localization.transactions_details_fee_amount(),
                                                    description: prettyFeeAmount(from: entity.feeAmount)))

        if transactionType == .deposit {
            transactionDetails.append(TransactionDetail(title: R.string.localization.transactions_details_type(),
                                                        description: R.string.localization.transactions_details_type_deposit() ))
        } else if transactionType == .withdraw {
            transactionDetails.append(TransactionDetail(title: R.string.localization.transactions_details_type(),
                                                        description: R.string.localization.transactions_details_type_withdraw() ))
        }

        transactionDetails.append(TransactionDetail(title: R.string.localization.transactions_details_payment_provider_name(),
                                                    description: String(entity.providerName)))

        return transactionDetails
    }

    private func consturctTransactionHistoryComponentViewModel(from entity: TransactionHistoryEntity, with details: [TransactionDetail]) -> DefaultTransactionHistoryComponentViewModel {
        let transactionType: TransactionType = entity.totalAmount < 0 ? .withdraw : .deposit
        var transactionHistory: TransactionHistory?

        if transactionType == .deposit {
            transactionHistory = TransactionHistory(title: entity.providerName ,
                                                    subtitle: R.string.localization.transactions_details_type_deposit(),
                                                    amount: prettyAmount(from: entity.totalAmount),
                                                    icon: R.image.transactionsHistory.deposit()!,
                                                    details: details)
        } else if transactionType == .withdraw {
            transactionHistory = TransactionHistory(title: entity.providerName ,
                                                    subtitle: R.string.localization.transactions_details_type_withdraw(),
                                                    amount: prettyAmount(from: entity.totalAmount),
                                                    icon: R.image.transactionsHistory.withdraw()!,
                                                    details: details)
        }
        let componentViewModel = DefaultTransactionHistoryComponentViewModel(params: .init(transactionHistory: transactionHistory!))
        return componentViewModel
    }

    private func prettyAmount(from rawAmount: Double) -> String {
        let flooredAmount = Double(rawAmount) / 100
        let finalString = String(format: "%.2f", flooredAmount)
        return finalString
    }

    private func prettyFeeAmount(from rawAmount: Double) -> String {
        let flooredAmount = Double(rawAmount) / 100
        return amountFormatter.format(number: flooredAmount, in: .sn)
    }
}
