//
//  AccountParametersViewController.swift
//  Mobile
//
//  Created by Irakli Shelia on 12/1/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public class AccountParametersViewController: ABViewController {
    @Inject(from: .viewModels) public var viewModel: AccountParametersViewModel
    public lazy var navigator = AccountParametersNavigator(viewController: self)
    private lazy var appTableViewController = ABTableViewController()

    // MARK: - Lifecycle methods
    public override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }

    // MARK: Bind to viewModel's observable properties
    private func bind(to viewModel: AccountParametersViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)

        viewModel.route.subscribe(onNext: { [weak self] route in
            self?.didRecive(route: route)
        }).disposed(by: disposeBag)
    }

    private func didRecive(action: AccountParametersViewModelOutputAction) {
        switch action {
        case .initialize(let appListDataProvider):
            self.appTableViewController.dataProvider = appListDataProvider
        case .languageDidChange:
            print("Handle language Change")
        }
    }

    private func didRecive(route: AccountParametersViewModelRoute) {
        switch route {
        case .openPage(let destination):
            navigator.navigate(to: destination, animated: true)
        case .openHighSecurity:
            navigator.navigate(to: .highSecurity, animated: true)
        case .openAccessHistory:
            navigator.navigate(to: .loginHistory, animated: true)
        case .openCloseAccount:
            navigator.navigate(to: .closeAccount, animated: true)
        }
    }

    // MARK: Setup methods
    private func setup() {
        setBaseBackgroundColor(to: .secondaryBg())
        setupNavigationItems()
        setupTableView()
    }

    private func setupNavigationItems() {
        setBackBarButtonItemIfNeeded()
        setTitle(title: R.string.localization.account_parameters.localized())
    }

    private func setupTableView() {
        add(child: appTableViewController)
        appTableViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            appTableViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 13),
            appTableViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            appTableViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            appTableViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        appTableViewController.isTabBarManagementEnabled = true
    }
}

extension AccountParametersViewController: CommonBarButtonProviding { }
