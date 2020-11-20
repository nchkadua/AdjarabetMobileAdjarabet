//
//  TransactionDetailsViewController.swift
//  Mobile
//
//  Created by Irakli Shelia on 11/19/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public class TransactionDetailsViewController: ABPopupViewController {
    public var viewModel: TransactionDetailsViewModel!
    public lazy var navigator = TransactionDetailsNavigator(viewController: self)
    private lazy var appTableViewController = ABTableViewController()
    // MARK: Outlets
    @IBOutlet private weak var separator: UIView!
    @IBOutlet private weak var headerTitleLabel: UILabel!
    // MARK: - Lifecycle methods
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupColors()
        setupFonts()
        setupTableView()
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }

    // MARK: Bind to viewModel's observable properties
    private func bind(to viewModel: TransactionDetailsViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)
    }

    private func setupColors() {
        setBaseBackgorundColor(to: .secondaryBg())
        separator.setBackgorundColor(to: .secondaryFill())
        headerTitleLabel.setTextColor(to: .primaryText())
    }

    private func setupFonts() {
        headerTitleLabel.setFont(to: .subHeadline(fontCase: .lower))
    }

    private func setupTableView() {
        add(child: appTableViewController)
        appTableViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            appTableViewController.view.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 18),
            appTableViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            appTableViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            appTableViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        appTableViewController.isTabBarManagementEnabled = true
    }

    private func didRecive(action: TransactionDetailsViewModelOutputAction) {
        switch action {
        case .initialize(let appListDataProvider):
            appTableViewController.dataProvider = appListDataProvider
        case .languageDidChange:
            // TODO
            print("Handle language Change")
        }
    }

    private func didRecive(route: TransactionDetailsViewModelRoute) {
    }
}

// MARK: - UIViewControllerTransitioningDelegate
extension TransactionDetailsViewController: UIViewControllerTransitioningDelegate {
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        ABPopupPresentationController(
            presentedViewController: presented,
            presenting: presenting,
            params: .init(
                heightConstant: 330 //TODO compute desired height
            )
        )
    }
}
