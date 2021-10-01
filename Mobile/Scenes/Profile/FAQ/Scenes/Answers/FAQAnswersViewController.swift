//
//  FAQAnswersViewController.swift
//  Mobile
//
//  Created by Nika Chkadua on 21.07.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public class FAQAnswersViewController: ABViewController {
    @Inject(from: .viewModels) var viewModel: FAQAnswersViewModel
    public lazy var navigator = FAQAnswersNavigator(viewController: self)

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var textView: UITextView!

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
    private func bind(to viewModel: FAQAnswersViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)

        viewModel.route.subscribe(onNext: { [weak self] route in
            self?.didRecive(route: route)
        }).disposed(by: disposeBag)
    }

    private func didRecive(action: FAQAnswersViewModelOutputAction) {
        switch action {
        case .setupWithQuestion(let question): setupWithQuestion(question)
        }
    }

    private func didRecive(route: FAQAnswersViewModelRoute) {
    }

    // MARK: Setup methods
    private func setup() {
        setBaseBackgroundColor(to: .secondaryBg())
        setupNavigationItems()
        setupTitle()
        setupTextView()
    }

    private func setupNavigationItems() {
        setTitle(title: R.string.localization.faq_title.localized())
        setBackBarButtonItemIfNeeded()

        guard viewModel.params.showDismissButton else { return }

        let dismissButtonGroup = makeBarButtonWith(title: R.string.localization.reset_password_dismiss_button_title.localized())
        navigationItem.rightBarButtonItem = dismissButtonGroup.barButtonItem
        dismissButtonGroup.button.addTarget(self, action: #selector(dismissButtonClick), for: .touchUpInside)
    }

    @objc private func dismissButtonClick() {
        dismiss(animated: true, completion: nil)
    }

    private func setupTitle() {
        titleLabel.setFont(to: .headline(fontCase: .lower, fontStyle: .regular))
        titleLabel.setTextColor(to: .primaryText())
    }

    private func setupTextView() {
        textView.setFont(to: .subHeadline(fontCase: .lower, fontStyle: .regular))
        textView.setTextColor(to: .secondaryText())
        textView.isEditable = false
        textView.isSelectable = false
    }

    private func setupWithQuestion(_ question: FAQQuestion) {
        titleLabel.text = question.title
        textView.attributedText = question.answer.htmlToAttributedString
    }
}

extension FAQAnswersViewController: CommonBarButtonProviding { }
