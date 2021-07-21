//
//  FAQAnswersViewController.swift
//  Mobile
//
//  Created by Nika Chkadua on 21.07.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public class FAQAnswersViewController: UIViewController {
    @Inject(from: .viewModels) public var viewModel: FAQAnswersViewModel
    public lazy var navigator = FAQAnswersNavigator(viewController: self)
    private let disposeBag = DisposeBag()

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var textView: UITextView!

    // MARK: - Lifecycle methods
    public override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        bind(to: viewModel)
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
        case .setTitle(let title): titleLabel.text = title
        }
    }

    private func didRecive(route: FAQAnswersViewModelRoute) {
    }

    // MARK: Setup methods
    private func setup() {
        setBaseBackgorundColor(to: .secondaryBg())
        setupNavigationItems()
        setupTitle()
        setupTextView()
    }

    private func setupNavigationItems() {
        setTitle(title: R.string.localization.faq_title.localized())
        setBackBarButtonItemIfNeeded()
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
}
