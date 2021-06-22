//
//  ProfileViewController.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/1/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public class ProfileViewController: ABViewController, PageViewControllerProtocol {
    // MARK: Properties
    @Inject(from: .viewModels) public var viewModel: ProfileViewModel
    public lazy var navigator = ProfileNavigator(viewController: self)

    private lazy var appTableViewController: AppTableViewController = AppTableViewController()

    // MARK: Overrides
    public override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    // MARK: - Lifecycle methods
    public override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        bind(to: viewModel)
        viewModel.viewDidLoad()
        generateAccessibilityIdentifiers()
    }

//    public override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        let vc = UIApplication.shared.currentWindow?.rootViewController as? MainContainerViewController
//        vc?.setPageViewControllerSwipeEnabled(true)
//    }
//
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        mainContainerViewController?.setPageViewControllerSwipeEnabled(false)
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
        case .didLogoutWithSuccess: navigator.navigate(to: .loginPage, animated: true)
        case .didLogoutWithError(let error): print("Logout with error , \(error)")
        }
    }

    private func didRecive(route: ProfileViewModelRoute) {
        switch route {
        case .openBalance: openBalance()
        case .openDeposit: openDeposit()
        case .openWithdraw: openWithdraw()
        case .openPage(let destination):
            switch destination {
            case .loginPage: viewModel.logout()
            default:
                openPage(destination: destination)
            }
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
        setBaseBackgorundColor(to: .secondaryBg())
        setupNavigationItems()
        setupTableView()
    }

    private func setupTableView() {
        add(child: appTableViewController)
        appTableViewController.view.translatesAutoresizingMaskIntoConstraints = false
        appTableViewController.view.pin(to: view)
        appTableViewController.setBaseBackgorundColor(to: .secondaryBg())

        appTableViewController.tableView?.register(types: [
            ProfileInfoTableViewCell.self,
            BalanceTableViewCell.self,
            QuickActionsHeaderCell.self,
            QuickActionTableViewCell.self,
            LogOutTableViewCell.self,
            FooterTableViewCell.self
        ])
    }

    private func setupNavigationItems() {
        let backButtonGroup = makeBackBarButtonItem()
        navigationItem.leftBarButtonItem = backButtonGroup.barButtonItem
        backButtonGroup.button.addTarget(self, action: #selector(navigateToMainTabBar), for: .touchUpInside)

        let userIdButton = userIdBarButtonItemGroup()
        navigationItem.rightBarButtonItem = userIdButton
    }

    @objc private func navigateToMainTabBar() {
        navigator.navigateToMainTabBar()
    }
}

extension ProfileViewController: CommonBarButtonProviding { }

extension ProfileViewController: Accessible {}
