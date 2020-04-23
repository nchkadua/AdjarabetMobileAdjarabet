//
//  NotificationsViewController.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/14/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public class NotificationsViewController: UIViewController {
    public var viewModel: NotificationsViewModel = DefaultNotificationsViewModel(params: NotificationsViewModelParams())
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
        setLeftBarButtonItemTitle(to: R.string.localization.notifications_page_title.localized())
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
        DefaultLanguageStorage.shared.update(language: .english)
    }

    @objc private func georgianButtonDidTap() {
        DefaultLanguageStorage.shared.update(language: .georgian)
    }

    @objc private func armenianButtonDidTap() {
        DefaultLanguageStorage.shared.update(language: .armenian)
    }
}

extension NotificationsViewController: CommonBarButtonProviding { }
