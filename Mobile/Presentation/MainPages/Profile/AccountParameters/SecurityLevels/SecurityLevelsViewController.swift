//
//  SecurityLevelsViewController.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 12/8/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public class SecurityLevelsViewController: ABViewController {
    @Inject(from: .viewModels) public var viewModel: SecurityLevelsViewModel
    public lazy var navigator = SecurityLevelsNavigator(viewController: self)
    private lazy var appTableViewController = SecurityLevelsTableViewController()

    // MARK: - Lifecycle methods
    public override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }

    // MARK: Bind to viewModel's observable properties
    private func bind(to viewModel: SecurityLevelsViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)
/*
        viewModel.route.subscribe(onNext: { [weak self] route in
            self?.didRecive(route: route)
        }).disposed(by: disposeBag)
*/
    }

    private func didRecive(action: SecurityLevelsViewModelOutputAction) {
        switch action {
        case .dataProvider(let dataProvider):
            appTableViewController.dataProvider = dataProvider
        }
    }

    private func didRecive(route: SecurityLevelsViewModelRoute) {
    }
}

// MARK: Helpers
extension SecurityLevelsViewController {
    private func setup() {
        setTitle(title: R.string.localization.security_levels_scene_title.localized())
        setBackDismissBarButtonItemIfNeeded(width: 44)
        setupTableView()
    }

    private func setupTableView() {
        add(child: appTableViewController)
        appTableViewController.view.translatesAutoresizingMaskIntoConstraints = false
        appTableViewController.isTabBarManagementEnabled = true
        NSLayoutConstraint.activate([
            appTableViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            appTableViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            appTableViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            appTableViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

private class SecurityLevelsTableViewController: ABTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("SecurityLevelsTableViewController", indexPath)
    }
}
