//
//  ContactUsViewController.swift
//  Mobile
//
//  Created by Nika Chkadua on 26.07.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public class ContactUsViewController: ABViewController {
    @Inject(from: .viewModels) public var viewModel: ContactUsViewModel
    public lazy var navigator = ContactUsNavigator(viewController: self)

    private lazy var appTableViewController: AppTableViewController = AppTableViewController()

    // MARK: - Lifecycle methods
    public override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }

    // MARK: Bind to viewModel's observable properties
    private func bind(to viewModel: ContactUsViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)

        viewModel.route.subscribe(onNext: { [weak self] route in
            self?.didRecive(route: route)
        }).disposed(by: disposeBag)
    }

    private func didRecive(action: ContactUsViewModelOutputAction) {
    }

    private func didRecive(route: ContactUsViewModelRoute) {
    }

    // MARK: Setup methods
    private func setup() {
        setBaseBackgorundColor(to: .secondaryBg())
        setupNavigationItems()
        setupTableView()
    }

    private func setupNavigationItems() {
        setTitle(title: R.string.localization.contact_use_title.localized())
        setBackDismissBarButtonItemIfNeeded(completion: #selector(backButtonClick))
    }

    private func setupTableView() {
        add(child: appTableViewController)
        appTableViewController.view.translatesAutoresizingMaskIntoConstraints = false
        appTableViewController.view.pin(to: view)
        appTableViewController.setBaseBackgorundColor(to: .secondaryBg())
        appTableViewController.tableView.isScrollEnabled = false

        appTableViewController.tableView?.register(types: [
        ])
    }

    // MARK: Action methods
    @objc private func backButtonClick() {
        if viewModel.params.showDismiss {
            navigationController?.dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
}
