//
//  PromotionsViewController.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/14/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public class PromotionsViewController: ABViewController {
    // MARK: Properties
    @Inject(from: .viewModels) private var viewModel: PromotionsViewModel

    public lazy var navigator = PromotionsNavigator(viewController: self)
    private lazy var appTableViewController = ABTableViewController()

    // MARK: Overrides
    public override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    public override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        bind(to: viewModel)
        viewModel.viewDidLoad()
        generateAccessibilityIdentifiers()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setMainContainerSwipeEnabled(false)
    }

    private func bind(to viewModel: PromotionsViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didReceive(action: action)
        }).disposed(by: disposeBag)
    }

    private func didReceive(action: PromotionsViewModelOutputAction) {
        switch action {
        case .languageDidChange:
            setup()
        case .initialize(let appListDataProvider):
            appTableViewController.dataProvider = appListDataProvider
        }
    }

    // MARK: Setup methods
    private func setup() {
        setBaseBackgorundColor(to: .primaryBg())
        setupNavigationItems()
        setupTableView()
    }

    private func setupNavigationItems() {
        makeAdjarabetLogo()

        let profileButtonGroup = makeBalanceBarButtonItem()
        navigationItem.rightBarButtonItem = profileButtonGroup.barButtonItem
        profileButtonGroup.button.addTarget(self, action: #selector(openProfile), for: .touchUpInside)
    }

    private func setupTableView() {
        add(child: appTableViewController)
        appTableViewController.view.translatesAutoresizingMaskIntoConstraints = false
        appTableViewController.view.pin(to: view)
        appTableViewController.isTabBarManagementEnabled = true
    }

    // MARK: Action methods
    @objc private func openProfile() {
//        navigator.navigate(to: .profile, animated: true)
    }
}

extension PromotionsViewController: CommonBarButtonProviding { }

extension PromotionsViewController: Accessible {}
