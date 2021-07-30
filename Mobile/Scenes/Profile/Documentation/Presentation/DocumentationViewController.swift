//
//  DocumentationViewController.swift
//  Mobile
//
//  Created by Nika Chkadua on 06.07.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public class DocumentationViewController: ABViewController {
    @Inject(from: .viewModels) public var viewModel: DocumentationViewModel
    public lazy var navigator = DocumentationNavigator(viewController: self)

    private lazy var appTableViewController: AppTableViewController = AppTableViewController()

    // MARK: - Lifecycle methods
    public override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }

    // MARK: Bind to viewModel's observable properties
    private func bind(to viewModel: DocumentationViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)

        viewModel.route.subscribe(onNext: { [weak self] route in
            self?.didRecive(route: route)
        }).disposed(by: disposeBag)
    }

    private func didRecive(action: DocumentationViewModelOutputAction) {
        switch action {
        case .initialize(let appListDataProvider): appTableViewController.dataProvider = appListDataProvider
        }
    }

    private func didRecive(route: DocumentationViewModelRoute) {
        switch route {
        case .openPage(let destination): navigateTo(destination)
        case .navigateToPrivacyPolicy(let params): navigator.navigate(to: .privacyPolicy(with: params), animated: true)
        }
    }

    private func navigateTo(_ destination: DocumentationDestination) {
        switch destination {
        case .termsAndConditions:
            navigator.navigate(to: .termsAndConditions(with: .init()), animated: true)
        case .privacyPolicy:
            viewModel.createPrivacyPolicyRequest()
        }
    }

    // MARK: Setup methods
    private func setup() {
        setBaseBackgroundColor(to: .secondaryBg())
        setupNavigationItems()
        setupTableView()
    }

    private func setupNavigationItems() {
        setTitle(title: R.string.localization.documentation_title.localized())
        setBackBarButtonItemIfNeeded()
    }

    private func setupTableView() {
        add(child: appTableViewController)
        appTableViewController.view.translatesAutoresizingMaskIntoConstraints = false
        appTableViewController.view.pin(to: view)
        appTableViewController.setBaseBackgroundColor(to: .secondaryBg())
        appTableViewController.tableView.isScrollEnabled = false

        appTableViewController.tableView?.register(types: [
            DocumentationActionTableViewCell.self
        ])
    }
}
