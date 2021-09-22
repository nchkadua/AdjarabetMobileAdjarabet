//
//  BonusViewController.swift
//  Mobile
//
//  Created by Nika Chkadua on 4/26/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public class BonusViewController: ABViewController {
    // MARK: Properties
    @Inject(from: .viewModels) var viewModel: BonusViewModel
    private lazy var navigator = BonusNavigator(viewController: self)
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

    private func setup() {
        setBaseBackgroundColor(to: .primaryBg())
        setupTableView()
    }

    private func setupTableView() {
        add(child: appTableViewController)
        appTableViewController.view.translatesAutoresizingMaskIntoConstraints = false
        appTableViewController.view.pin(to: view)

        appTableViewController.isTabBarManagementEnabled = true
        appTableViewController.canEditRow = true
        appTableViewController.delegate = viewModel
    }

    // MARK: Bind to viewModel's observable properties
    private func bind(to viewModel: BonusViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didReceive(action: action)
        }).disposed(by: disposeBag)

        viewModel.route.subscribe(onNext: { [weak self] route in
            self?.didReceive(route: route)
        }).disposed(by: disposeBag)
    }

    private func didReceive(action: BonusViewModelOutputAction) {
        switch action {
        case .initialize(let appListDataProvider):
            appTableViewController.dataProvider = appListDataProvider
        case .reload:
            break // TODO
        case .reloadItems(let items, let insertions, let deletions):
            UIView.performWithoutAnimation {
                appTableViewController.reloadItems(items: items, insertionIndexPathes: insertions, deletionIndexPathes: deletions)
            }
        case .reloadData:
            appTableViewController.reloadItems()
        case .didDeleteCell(let indexPath):
            deleteCell(at: indexPath)
        case .setTotalItemsCount:
            break // TODO
        }
    }

    private func didReceive(route: BonusViewModelRoute) {
    }

    // MARK: Action methods
    private func deleteCell(at indexPath: IndexPath) {
        appTableViewController.reloadItems(deletionIndexPathes: [indexPath])
//        viewModel.viewWillAppear()
    }
}
