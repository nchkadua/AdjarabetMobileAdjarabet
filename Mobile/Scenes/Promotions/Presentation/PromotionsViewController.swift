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

    @IBOutlet private weak var tableViewContainer: UIView!
    @IBOutlet private weak var promoTab: PromoTabComponentView!

    // MARK: Overrides
    public override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    public override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        bind(to: viewModel)
        errorThrowing = viewModel
        viewModel.viewDidLoad()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
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
        case .bindToPromoTabViewModel(let viewModel):
            bindToTab(viewModel)
        }
    }

    // MARK: Setup methods
    private func setup() {
        setBaseBackgroundColor(to: .primaryBg())
        setupNavigationItems()
        setupTableView()
    }

    private func setupNavigationItems() {
    }

    private func setupTableView() {
        add(child: appTableViewController)
        appTableViewController.view.translatesAutoresizingMaskIntoConstraints = false
        appTableViewController.view.pin(to: tableViewContainer)
        appTableViewController.isTabBarManagementEnabled = true
    }

    /// Promo Tab
    private func bindToTab(_ viewModel: PromoTabComponentViewModel) {
        promoTab.setAndBind(viewModel: viewModel)
        bind(to: viewModel)
    }

    private func bind(to viewModel: PromoTabComponentViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)
    }

    private func didRecive(action: PromoTabComponentViewModelOutputAction) {
        switch action {
        case .buttonPublicDidTap: viewModel.fetchPublicPromos()
        case .buttonPrivateDidTap: viewModel.fetchPrivatePromos()
        }
    }
}

extension PromotionsViewController: CommonBarButtonProviding { }
