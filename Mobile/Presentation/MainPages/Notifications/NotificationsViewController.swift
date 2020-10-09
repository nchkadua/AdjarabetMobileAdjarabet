//
//  NotificationsViewController.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/14/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public class NotificationsViewController: UIViewController {
    @Inject(from: .viewModels) private var viewModel: NotificationsViewModel
    private let disposeBag = DisposeBag()
    public lazy var navigator = NotificationsNavigator(viewController: self)

    public override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    public override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }

    private func setup() {
        setBaseBackgorundColor()
        setupNavigationItems()
    }

    private func setupNavigationItems() {
        makeLeftBarButtonItemTitle(to: R.string.localization.notifications_page_title.localized())

        let profileButtonGroup = makeBalanceBarButtonItem()
        navigationItem.rightBarButtonItem = profileButtonGroup.barButtonItem
        profileButtonGroup.button.addTarget(self, action: #selector(openProfile), for: .touchUpInside)
    }

    @objc private func openProfile() {
        navigator.navigate(to: .profile, animated: true)
    }

    private func bind(to viewModel: NotificationsViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didReceive(action: action)
        }).disposed(by: disposeBag)
    }

    private func didReceive(action: NotificationsViewModelOutputAction) {
        switch action {
        case .languageDidChange:
            setup()
        }
    }

    @objc private func englishButtonDidTap() {
        changeLanguage(to: .english)
    }

    @objc private func georgianButtonDidTap() {
        changeLanguage(to: .georgian)
    }

    @objc private func armenianButtonDidTap() {
        changeLanguage(to: .armenian)
    }

    private func changeLanguage(to language: Language) {
        DefaultLanguageStorage.shared.update(language: language)
        UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
    }
}

extension NotificationsViewController: CommonBarButtonProviding { }
