//
//  PromotionsViewController.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/14/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public class PromotionsViewController: ABViewController {
    // MARK: Properties
    @Inject(from: .viewModels) private var viewModel: PromotionsViewModel

    public lazy var navigator = PromotionsNavigator(viewController: self)
    private lazy var appTableViewController = ABTableViewController()

    // MARK: Overrides
    public override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    public override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        bind(to: viewModel)
        errorThrowing = viewModel
        viewModel.viewDidLoad()
    }

    private func bind(to viewModel: PromotionsViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didReceive(action: action)
        }).disposed(by: disposeBag)
    }

    private func didReceive(action: PromotionsViewModelOutputAction) {
        switch action {
        case .languageDidChange:
            setup()
        case .initialize(let appListDataProvider):
            appTableViewController.dataProvider = appListDataProvider
        }
    }

    // MARK: Setup methods
    private func setup() {
        setBaseBackgroundColor(to: .primaryBg())
        setupNavigationItems()
        setupTableView()
		setupStatusMessage()
    }

    private func setupNavigationItems() {
        makeAdjarabetLogo()
    }

    private func setupTableView() {
        add(child: appTableViewController)
        appTableViewController.view.translatesAutoresizingMaskIntoConstraints = false
        appTableViewController.view.pin(to: view)
        appTableViewController.isTabBarManagementEnabled = true
    }
	
	private func setupStatusMessage() {
		view.bringSubviewToFront(statusMessage.view)
	}
}

extension PromotionsViewController: CommonBarButtonProviding { }
