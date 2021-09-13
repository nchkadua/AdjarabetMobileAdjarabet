//
//  TransactionsViewController.swift
//  Mobile
//
//  Created by Irakli Shelia on 11/16/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

class TransactionsViewController: ABViewController {
    // MARK: Properties
    @Inject(from: .viewModels) private var viewModel: TransactionsViewModel
    public lazy var navigator = TransactionsNavigator(viewController: self)
    private lazy var appTableViewController = ABTableViewController()
		.configureEmptyState(with: viewModel.emptyStateViewModel)
        .enableEmptyState()

    // MARK: - Lifecycle methods
    public override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bind(to: viewModel)
        errorThrowing = viewModel
        viewModel.viewDidLoad()
    }

    // MARK: Bind to viewModel's observable properties
    private func bind(to viewModel: TransactionsViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)

        viewModel.route.subscribe(onNext: { [weak self] route in
            self?.didRecive(route: route)
        }).disposed(by: disposeBag)
    }

    private func didRecive(action: TransactionsViewModelOutputAction) {
        switch action {
        case .initialize(let appListDataProvider):
            appTableViewController.dataProvider = appListDataProvider
            if appListDataProvider.IsEmpty { showEmptyPage() }
        case .languageDidChange:
            print("Handle language Change")
        case .reloadItems(let items, let insertionIndexPathes, let deletionIndexPathes):
            UIView.performWithoutAnimation {
                appTableViewController.reloadItems(items: items, insertionIndexPathes: insertionIndexPathes, deletionIndexPathes: deletionIndexPathes)
            }
        case .isLoading(let loading):
            loading ? startLoading() : stopLoading()
        }
    }

    private func didRecive(route: TransactionsViewModelRoute) {
        switch route {
        case .openTransactionDetails(let transactionHistory):
            openTransactionDetails(with: transactionHistory)
        case .openTransactionFilter(let params):
            openTransactionsFilter(params: params)
        }
    }

    private func openTransactionDetails(with transactionHistory: TransactionHistory) {
        navigator.navigate(to: .transactionDetails(params: .init(transactionHistory: transactionHistory)), animated: true)
    }

    // MARK: Setup methods
    private func setup() {
        setBaseBackgroundColor(to: .primaryBg())
        setupNavigationItems()
        setupTableView()
    }

    private func setupNavigationItems() {
        setBackBarButtonItemIfNeeded()
        setTitle(title: R.string.localization.transactions_title.localized())

        let calendarButton = makeCalendarBarButtonItem()
        navigationItem.rightBarButtonItem = calendarButton.barButtonItem
        calendarButton.button.addTarget(self, action: #selector(calendarTabItemClicked), for: .touchUpInside)
    }

    @objc private func calendarTabItemClicked() {
        viewModel.calendarTabItemClicked()
    }

    private func openTransactionsFilter(params: TransactionsFilterViewModelParams) {
        navigator.navigate(to: .filter(params: params), animated: true)
    }

    private func setupTableView() {
        add(child: appTableViewController)
        appTableViewController.view.translatesAutoresizingMaskIntoConstraints = false
        appTableViewController.view.pin(to: view)
        appTableViewController.isTabBarManagementEnabled = true
        appTableViewController.delegate = viewModel
    }

    private func showEmptyPage() {
        // TODO: Nika
    }
}

extension TransactionsViewController: CommonBarButtonProviding { }
