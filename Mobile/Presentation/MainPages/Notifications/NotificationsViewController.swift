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

    public override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    public override func viewDidLoad() {
        super.viewDidLoad()

        setupLanguageButtons()
        setup()
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }

    private func setupLanguageButtons() {
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "🇬🇧", style: .plain, target: self, action: #selector(englishButtonDidTap)),
            UIBarButtonItem(title: "🇬🇪", style: .plain, target: self, action: #selector(georgianButtonDidTap)),
            UIBarButtonItem(title: "🇦🇲", style: .plain, target: self, action: #selector(armenianButtonDidTap))
        ]
    }

    private func setup() {
        setBaseBackgorundColor()
        makeLeftBarButtonItemTitle(to: R.string.localization.notifications_page_title.localized())
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