//
//  FAQCategoriesViewController.swift
//  Mobile
//
//  Created by Nika Chkadua on 20.07.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public class FAQCategoriesViewController: ABViewController {
    @Inject(from: .viewModels) var viewModel: FAQCategoriesViewModel
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
        errorThrowing = viewModel
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
        case .isLoading(let loading):
            loading ? startLoading() : stopLoading()
        }
    }

    private func didRecive(route: FAQCategoriesViewModelRoute) {
        switch route {
        case .navigateToQuestions(let questions): navigator.navigate(to: .questions(questions: questions, shouldShowDismissButton: viewModel.params.showDismissButton), animated: true)
        }
    }

    // MARK: Setup methods
    private func setup() {
        setBaseBackgroundColor(to: .secondaryBg())
        setupNavigationItems()
        setupTableView()
        setupTitleLabel()
        setupImageView()
    }

    private func setupNavigationItems() {
        setTitle(title: R.string.localization.faq_title.localized())
        setBackDismissBarButtonItemIfNeeded(completion: #selector(backButtonClick))
    }

    @objc private func backButtonClick() {
        if viewModel.params.showDismissButton {
            navigationController?.dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }

    private func setupTableView() {
        add(child: appTableViewController)
        appTableViewController.view.translatesAutoresizingMaskIntoConstraints = false
        appTableViewController.view.pin(to: containerView)
        appTableViewController.setBaseBackgroundColor(to: .secondaryBg())

        appTableViewController.tableView?.register(types: [
            FAQCategoryTableViewCell.self
        ])
    }

    private func setupTitleLabel() {
        titleLabel.setFont(to: .headline(fontCase: .lower, fontStyle: .semiBold))
        titleLabel.setTintColor(to: .primaryText())
        titleLabel.text = R.string.localization.faq_subtitle.localized().uppercased()
    }

    private func setupImageView() {
        bannerImageView.contentMode = .scaleAspectFill
        bannerImageView.image = R.image.faQ.banner()!
    }
}

extension FAQCategoriesViewController: CommonBarButtonProviding { }
