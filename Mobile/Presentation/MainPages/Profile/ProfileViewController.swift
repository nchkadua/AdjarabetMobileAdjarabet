//
//  ProfileViewController.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/1/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public class ProfileViewController: UIViewController {
    // MARK: Properties
    @Inject(from: .viewModels) private var viewModel: ProfileViewModel
    public lazy var navigator = ProfileNavigator(viewController: self)
    private let disposeBag = DisposeBag()

    private lazy var appTableViewController: AppTableViewController = AppTableViewController()

    // MARK: Overrides
    public override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    // MARK: - Lifecycle methods
    public override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }

    // MARK: Bind to viewModel's observable properties
    private func bind(to viewModel: ProfileViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)

        viewModel.route.subscribe(onNext: { [weak self] route in
            self?.didRecive(route: route)
        }).disposed(by: disposeBag)
    }

    private func didRecive(action: ProfileViewModelOutputAction) {
        switch action {
        case .initialize(let appListDataProvider): appTableViewController.dataProvider = appListDataProvider
        case .didCopyUserId(let userId): didCopyUserId(userId: userId)
        }
    }

    private func didRecive(route: ProfileViewModelRoute) {
        switch route {
        case .openBalance: openBalance()
        case .openDeposit: openDeposit()
        case .openWithdraw: openWithdraw()
        case .openPage(let destination): openPage(destination: destination)
        }
    }

    // MARK: Navigation methods
    private func didCopyUserId(userId: String) {
    }

    private func openBalance() {
    }

    private func openDeposit() {
        navigator.navigate(to: .deposit, animated: true)
    }

    private func openWithdraw() {
        navigator.navigate(to: .withdraw, animated: true)
    }

    private func openPage(destination: ProfileNavigator.Destination) {
        navigator.navigate(to: destination, animated: true)
    }

    // MARK: Setup methods
    private func setup() {
        setBaseBackgorundColor(to: .baseBg300())
        setupNavigationItems()
        setupTableView()
    }

    private func setupTableView() {
        add(child: appTableViewController)
        appTableViewController.view.translatesAutoresizingMaskIntoConstraints = false
        appTableViewController.view.pin(to: view)
        appTableViewController.tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true

        appTableViewController.tableView?.register(types: [
            ProfileInfoTableViewCell.self,
            BalanceTableViewCell.self,
            QuickActionsHeaderCell.self,
            QuickActionTableViewCell.self,
            FooterTableViewCell.self
        ])
    }

    private func setupNavigationItems() {
        makeRightBarButtonItemTitle(to: R.string.localization.profile_page_title.localized())
        setDismissBarButtonItemIfNeeded(width: 44)
    }
}

extension ProfileViewController: CommonBarButtonProviding { }
