//
//  CardInfoViewController.swift
//  Mobile
//
//  Created by Nika Chkadua on 2/5/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift
import WebKit

public class CardInfoViewController: ABViewController {
    @Inject(from: .viewModels) public var viewModel: CardInfoViewModel
    public lazy var navigator = CardInfoNavigator(viewController: self)

    private lazy var webView: WKWebView = {
        WKWebView()
    }()

    // MARK: - Lifecycle methods
    public override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }

    // MARK: Bind to viewModel's observable properties
    private func bind(to viewModel: CardInfoViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)
    }

    private func didRecive(action: CardInfoViewModelOutputAction) {
    }

    // MARK: Setup methods
    private func setup() {
        setBaseBackgorundColor(to: .secondaryBg())
        setupNavigationItems()
        setupWebView()
    }

    private func setupNavigationItems() {
        setBackBarButtonItemIfNeeded()
    }

    private func setupWebView() {
        webView.translatesAutoresizingMaskIntoConstraints = false

        webView.backgroundColor = .clear
        webView.isOpaque = false
        view.addSubview(webView)
        webView.pin(to: view)
    }
}

extension CardInfoViewController: CommonBarButtonProviding { }
