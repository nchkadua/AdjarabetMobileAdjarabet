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
        case .openOkCancelAlert(let title, let completion):
            openOkCancelAlert(title, completion)
        }
    }

    private func didRecive(route: SecurityLevelsViewModelRoute) {
    }
}

// MARK: Helpers
extension SecurityLevelsViewController {
    private func setup() {
        appTableViewController.viewModel = viewModel
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

    private func openOkCancelAlert(_ title: String, _ completion: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in completion(true) }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in completion(false) }))
        present(alert, animated: true, completion: nil)
    }
}

private class SecurityLevelsTableViewController: ABTableViewController {
    var viewModel: SecurityLevelsViewModel!
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRow(at: indexPath)
    }
}
