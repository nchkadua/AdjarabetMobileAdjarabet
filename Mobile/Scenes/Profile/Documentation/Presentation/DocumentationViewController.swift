//
//  DocumentationViewController.swift
//  Mobile
//
//  Created by Nika Chkadua on 06.07.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public class DocumentationViewController: ABViewController {
    @Inject(from: .viewModels) var viewModel: DocumentationViewModel
    public lazy var navigator = DocumentationNavigator(viewController: self)

    private lazy var appTableViewController: AppTableViewController = AppTableViewController()
    @IBOutlet weak var containerView: UIView!

    // MARK: - Lifecycle methods
    public override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        bind(to: viewModel)
        errorThrowing = viewModel
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
        case .openPage(let destination):
            navigateTo(destination)
        case .navigateToAboutUs(let params):
            navigator.navigate(to: .aboutUs(with: params), animated: true)
        case .navigateToPrivacyPolicy(let params):
            navigator.navigate(to: .privacyPolicy(with: params), animated: true)
		case .navigateToTermsAndConditions(let params):
			navigator.navigate(to: .termsAndConditions(with: .init(categories: params.list)), animated: true)
        }
    }

    private func navigateTo(_ destination: DocumentationDestination) {
        switch destination {
        case .aboutUs:
            viewModel.createAboutUsRequest()
        case .privacyPolicy:
            viewModel.createPrivacyPolicyRequest()
		case .termsAndConditions:
            viewModel.createTermsAndConditionsRequest()
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
        appTableViewController.view.pin(to: containerView)
        appTableViewController.setBaseBackgroundColor(to: .secondaryBg())
        appTableViewController.tableView.isScrollEnabled = false

        appTableViewController.tableView?.register(types: [
            DocumentationActionTableViewCell.self
        ])
    }
}
