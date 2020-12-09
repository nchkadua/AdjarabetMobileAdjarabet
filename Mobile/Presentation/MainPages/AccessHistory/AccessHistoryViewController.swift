//
//  AccessHistoryViewController.swift
//  Mobile
//
//  Created by Irakli Shelia on 12/7/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public class AccessHistoryViewController: ABViewController {
    @Inject(from: .viewModels) public var viewModel: AccessHistoryViewModel
    public lazy var navigator = AccessHistoryNavigator(viewController: self)
    private lazy var appTableViewController = ABTableViewController()
    // MARK: - Lifecycle methods
    public override func viewDidLoad() {
        super.viewDidLoad()

        bind(to: viewModel)
        setup()
        viewModel.viewDidLoad()
    }

    // MARK: Bind to viewModel's observable properties
    private func bind(to viewModel: AccessHistoryViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)

        viewModel.route.subscribe(onNext: { [weak self] route in
            self?.didRecive(route: route)
        }).disposed(by: disposeBag)
    }

    private func didRecive(action: AccessHistoryViewModelOutputAction) {
        switch action {
        case .initialize(let appListDataProvider):
            appTableViewController.dataProvider = appListDataProvider
        default:
            break
        }
    }

    private func didRecive(route: AccessHistoryViewModelRoute) {
    }

    // MARK: Setup methods

    private func setup() {
        setBaseBackgorundColor(to: .primaryBg())
        setupNavigationItems()
        setupTableView()
    }

    private func setupNavigationItems() {
        setBackBarButtonItemIfNeeded()
        setTitle(title: "შესვლის ისტორია")

        let calendarButton = makeCalendarBarButtonItem()
        navigationItem.rightBarButtonItem = calendarButton.barButtonItem
        calendarButton.button.addTarget(self, action: #selector(calendarTabItemClicked), for: .touchUpInside)
    }

    private func setupTableView() {
        add(child: appTableViewController)
        appTableViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            appTableViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            appTableViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            appTableViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            appTableViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        appTableViewController.isTabBarManagementEnabled = true
        appTableViewController.delegate = viewModel
    }

    @objc private func calendarTabItemClicked() {
//        viewModel.calendarTabItemClicked()
    }
}

extension AccessHistoryViewController: CommonBarButtonProviding { }
