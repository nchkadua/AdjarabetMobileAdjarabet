//
//  FAQQuestionsViewController.swift
//  Mobile
//
//  Created by Nika Chkadua on 20.07.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public class FAQQuestionsViewController: ABViewController {
    @Inject(from: .viewModels) var viewModel: FAQQuestionsViewModel
    public lazy var navigator = FAQQuestionsNavigator(viewController: self)

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
    private func bind(to viewModel: FAQQuestionsViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)

        viewModel.route.subscribe(onNext: { [weak self] route in
            self?.didRecive(route: route)
        }).disposed(by: disposeBag)
    }

    private func didRecive(action: FAQQuestionsViewModelOutputAction) {
        switch action {
        case .initialize(let appListDataProvider): appTableViewController.dataProvider = appListDataProvider
        }
    }

    private func didRecive(route: FAQQuestionsViewModelRoute) {
        switch route {
        case .navigateToAnswers(let questionTitle): navigator.navigate(to: .answers(shouldShowDismissButton: viewModel.params.showDismissButton, question: questionTitle), animated: true)
        }
    }

    // MARK: Setup methods
    private func setup() {
        setBaseBackgroundColor(to: .secondaryBg())
        setupNavigationItems()
        setupTableView()
    }

    private func setupNavigationItems() {
        setTitle(title: R.string.localization.faq_title.localized())
        setBackBarButtonItemIfNeeded()

        guard viewModel.params.showDismissButton else {return}

        let dismissButtonGroup = makeBarrButtonWith(title: R.string.localization.reset_password_dismiss_button_title.localized())
        navigationItem.rightBarButtonItem = dismissButtonGroup.barButtonItem
        dismissButtonGroup.button.addTarget(self, action: #selector(dismissButtonClick), for: .touchUpInside)
    }

    @objc private func backButtonClick() {
        if viewModel.params.showDismissButton {
            navigationController?.popToRootViewController(animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }

    @objc private func dismissButtonClick() {
        dismiss(animated: true, completion: nil)
    }

    private func setupTableView() {
        add(child: appTableViewController)
        appTableViewController.view.translatesAutoresizingMaskIntoConstraints = false
        appTableViewController.view.pin(to: view)
        appTableViewController.setBaseBackgroundColor(to: .secondaryBg())

        appTableViewController.tableView?.register(types: [
            FAQQuestionTableViewCell.self
        ])
    }
}

extension FAQQuestionsViewController: CommonBarButtonProviding { }
