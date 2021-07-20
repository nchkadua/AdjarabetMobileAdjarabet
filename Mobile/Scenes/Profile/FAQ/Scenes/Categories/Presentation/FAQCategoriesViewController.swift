//
//  FAQCategoriesViewController.swift
//  Mobile
//
//  Created by Nika Chkadua on 20.07.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public class FAQCategoriesViewController: ABViewController {
    @Inject(from: .viewModels) public var viewModel: FAQCategoriesViewModel
    public lazy var navigator = FAQCategoriesNavigator(viewController: self)

    private lazy var appTableViewController: AppTableViewController = AppTableViewController()

    @IBOutlet weak private var bannerImageView: UIImageView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var containerView: UIView!

    // MARK: - Lifecycle methods
    public override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }

    // MARK: Bind to viewModel's observable properties
    private func bind(to viewModel: FAQCategoriesViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)

        viewModel.route.subscribe(onNext: { [weak self] route in
            self?.didRecive(route: route)
        }).disposed(by: disposeBag)
    }

    private func didRecive(action: FAQCategoriesViewModelOutputAction) {
        switch action {
        case .initialize(let appListDataProvider): appTableViewController.dataProvider = appListDataProvider
        }
    }

    private func didRecive(route: FAQCategoriesViewModelRoute) {
    }

    // MARK: Setup methods
    private func setup() {
        setBaseBackgorundColor(to: .secondaryBg())
        setupNavigationItems()
        setupTableView()
        setupTitleLabel()
        setupImageView()
    }

    private func setupNavigationItems() {
        setTitle(title: R.string.localization.faq_title.localized())
        setBackBarButtonItemIfNeeded()
    }

    private func setupTableView() {
        add(child: appTableViewController)
        appTableViewController.view.translatesAutoresizingMaskIntoConstraints = false
        appTableViewController.view.pin(to: containerView)
        appTableViewController.setBaseBackgorundColor(to: .secondaryBg())

        appTableViewController.tableView?.register(types: [
            FAQCategoryTableViewCell.self
        ])
    }

    private func setupTitleLabel() {
        titleLabel.setFont(to: .headline(fontCase: .lower, fontStyle: .semiBold))
        titleLabel.setTintColor(to: .primaryText())
        titleLabel.text = R.string.localization.faq_subtitle.localized()
    }

    private func setupImageView() {
        bannerImageView.contentMode = .scaleAspectFill
        bannerImageView.image = R.image.faQ.banner()!
    }
}
