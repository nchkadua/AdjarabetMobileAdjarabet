//
//  MyCardsViewController.swift
//  Mobile
//
//  Created by Irakli Shelia on 1/20/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift
import UIKit

public class MyCardsViewController: ABViewController {
    public lazy var navigator = MyCardsNavigator(viewController: self)
    @Inject(from: .viewModels) private var viewModel: MyCardsViewModel
    private lazy var appTableViewController = ABTableViewController()

    // MARK: - Lifecycle methods
    public override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bind(to: viewModel)
        viewModel.viewDidLoad()
        generateAccessibilityIdentifiers()
    }

    // MARK: Bind to viewModel's observable properties
    private func bind(to viewModel: MyCardsViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)
        /*
        viewModel.route.subscribe(onNext: { [weak self] route in
            self?.didRecive(route: route)
        }).disposed(by: disposeBag)
        */
    }

    private func didRecive(action: MyCardsViewModelOutputAction) {
        switch action {
        case .initialize(let dataProvider):
            self.appTableViewController.dataProvider = dataProvider
        case .didDeleteCell(let indexPath):
            deleteCell(at: indexPath)
        }
    }

    private func didRecive(route: MyCardsViewModelRoute) {
    }

    // MARK: Setup methods
    private func setup() {
        setBaseBackgroundColor(to: .primaryBg())
        setupNavigationItems()
        setupTableView()
    }

    private func setupTableView() {
        add(child: appTableViewController)
        appTableViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            appTableViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            appTableViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            appTableViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            appTableViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        appTableViewController.isTabBarManagementEnabled = true
        appTableViewController.canEditRow = true
    }

    private func deleteCell(at indexPath: IndexPath) {
        viewModel.deleteCell(at: indexPath.row)
        appTableViewController.reloadItems(deletionIndexPathes: [indexPath])
    }

    private func setupNavigationItems() {
        setBackBarButtonItemIfNeeded()
        setTitle(title: R.string.localization.my_cards_manage())

        let addCardsButton = makeAddCardBarButonItem()
        navigationItem.rightBarButtonItem = addCardsButton.barButtonItem
        addCardsButton.button.addTarget(self, action: #selector(addCardTabItemClicked), for: .touchUpInside)
    }

    @objc private func addCardTabItemClicked() {
        viewModel.addCardsClicked()
    }
}

extension MyCardsViewController: CommonBarButtonProviding { }

extension MyCardsViewController: Accessible {}
