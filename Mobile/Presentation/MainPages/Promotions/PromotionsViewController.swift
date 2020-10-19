//
//  PromotionsViewController.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/14/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public class PromotionsViewController: UIViewController {
    // MARK: Properties
    @Inject(from: .viewModels) private var viewModel: PromotionsViewModel
    private let disposeBag = DisposeBag()

    public lazy var navigator = PromotionsNavigator(viewController: self)
    private lazy var appTableViewController = ABTableViewController()

    // MARK: Overrides
    public override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    public override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        bind(to: viewModel)
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
        setBaseBackgorundColor(to: .baseBg300())
        setupNavigationItems()
        setupTableView()
    }

    private func setupNavigationItems() {
        makeLeftBarButtonItemTitle(to: R.string.localization.promotions_page_title.localized())

        let profileButtonGroup = makeBalanceBarButtonItem()
        navigationItem.rightBarButtonItem = profileButtonGroup.barButtonItem
        profileButtonGroup.button.addTarget(self, action: #selector(openProfile), for: .touchUpInside)
    }

    private func setupTableView() {
        add(child: appTableViewController)
        appTableViewController.view.translatesAutoresizingMaskIntoConstraints = false
        appTableViewController.view.pin(to: view)
        appTableViewController.isTabBarManagementEnabled = true
    }

    // MARK: Action methods
    @objc private func openProfile() {
        navigator.navigate(to: .profile, animated: true)
    }
}

extension PromotionsViewController: CommonBarButtonProviding { }
