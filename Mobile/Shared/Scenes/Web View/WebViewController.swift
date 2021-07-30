//
//  WebViewController.swift
//  Mobile
//
//  Created by Nika Chkadua on 3/10/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift
import WebKit

public class WebViewController: UIViewController {
    public var viewModel: WebViewModel!
    private let disposeBag = DisposeBag()
    private let webView = WKWebView()

    // MARK: - Lifecycle methods
    public override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }

    // MARK: Bind to viewModel's observable properties
    private func bind(to viewModel: WebViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)
    }

    private func didRecive(action: WebViewModelOutputAction) {
        switch action {
        case .load(let request): load(request)
        }
    }

    // MARK: Setup methods
    private func setup() {
        setBaseBackgroundColor(to: .primaryBg())
        setupNavigationItems()
        setupWebView()
    }

    private func setupNavigationItems() {
        setDismissBarButtonItemIfNeeded(width: 44)
    }

    private func setupWebView() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.backgroundColor = .clear
        webView.isOpaque = false
        view.addSubview(webView)
        webView.pinSafely(to: view)
    }

    // MARK: Action methods
    private func load(_ request: URLRequest) {
        webView.load(request as URLRequest)
    }
}
