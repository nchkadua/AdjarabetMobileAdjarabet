//
//  TermsAndConditionsViewController.swift
//  Mobile
//
//  Created by Giga Khizanishvili on 30.07.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public class TermsAndConditionsViewController: ABViewController {
    @Inject(from: .viewModels) var viewModel: TermsAndConditionsViewModel
	@Inject(from: .factories) private var webViewControllerFactory: WebViewControllerFactory
	
    public lazy var navigator = TermsAndConditionsNavigator(viewController: self)

    private lazy var appTableViewController: AppTableViewController = AppTableViewController()

    // MARK: - Lifecycle methods
    public override func viewDidLoad() {
        setInteractivePopGestureRecognizer = false
        super.viewDidLoad()

        setup()
        bind(to: viewModel)
        errorThrowing = viewModel
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
        switch action {
        case .initialize(let dataprovider):
            appTableViewController.dataProvider = dataprovider
        }
    }

    private func didRecive(route: TermsAndConditionsViewModelRoute) {
        switch route {
        case .openPage(let destination):
//            showAlert(title: destination)
			if let content = viewModel.params.categories.first(where: {$0.title == destination})?.html {
				let vc = webViewControllerFactory.make(params: .init(loadType: .html(html: content)))
				let navc = vc.wrapInNavWith(presentationStyle: .fullScreen)
				navc.navigationBar.styleForPrimaryPage()
				navigationController?.present(navc, animated: true, completion: nil)
			}
        }
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

        appTableViewController.tableView?.register(types: [
            TermsAndConditionsTableViewCell.self
        ])
    }
}
