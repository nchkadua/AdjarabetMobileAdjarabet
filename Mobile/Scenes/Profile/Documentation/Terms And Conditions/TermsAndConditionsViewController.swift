//
//  TermsAndConditionsViewController.swift
//  Mobile
//
//  Created by Giga Khizanishvili on 30.07.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public class TermsAndConditionsViewController: ABViewController {
    @Inject(from: .viewModels) public var viewModel: TermsAndConditionsViewModel
    public lazy var navigator = TermsAndConditionsNavigator(viewController: self)
    
    private lazy var appTableViewController: AppTableViewController = AppTableViewController()

    // MARK: - Lifecycle methods
    public override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }

    // MARK: Bind to viewModel's observable properties
    private func bind(to viewModel: TermsAndConditionsViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)

        viewModel.route.subscribe(onNext: { [weak self] route in
            self?.didRecive(route: route)
        }).disposed(by: disposeBag)
    }

    private func didRecive(action: TermsAndConditionsViewModelOutputAction) {
    }
    
    private func didRecive(route: TermsAndConditionsViewModelRoute) {
    }
    
    // MARK: Setup methods
    private func setup() {
        setBaseBackgroundColor(to: .secondaryBg())
        setupNavigationItems()
        setupTableView()
    }
    
    private func setupNavigationItems() {
        setTitle(title: R.string.localization.terms_and_conditions.localized())
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
