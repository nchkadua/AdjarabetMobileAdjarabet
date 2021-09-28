//
//  WebViewController.swift
//  Mobile
//
//  Created by Nika Chkadua on 3/10/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift
import WebKit

public class WebViewController: ABViewController {
    var viewModel: WebViewModel!
    private let webView = WKWebView()
    @IBOutlet private weak var webViewContainer: UIView!
    @IBOutlet private weak var headerComponentView: WebViewHeaderComponentView!
    private var isLoaded = false

    // MARK: - Lifecycle methods
    public override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        bind(to: viewModel)
        errorThrowing = viewModel
        viewModel.viewDidLoad()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    // MARK: Bind to viewModel's observable properties
    private func bind(to viewModel: WebViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)
    }

    private func didRecive(action: WebViewModelOutputAction) {
        switch action {
        case .loadRequst(let request): load(request)
        case .loadHtml(let html): load(html)
        case .bindToHeaderViewModel(let viewModel, let navigationEnabled): bindToHeader(viewModel, navigationEnabled)
        case .dismiss: dismiss(animated: true, completion: nil)
        case .goBack:
            guard webView.canGoBack else {return}
            webView.goBack()
        case .goForward:
            guard webView.canGoForward else {return}
            webView.goForward()
        case .reload:
            webView.reload()
        }
    }

    /// Header
    private func bindToHeader(_ headerViewModel: WebViewHeaderComponentViewModel, _ navigationEnabled: Bool) {
        headerComponentView.setAndBind(viewModel: headerViewModel)
        headerViewModel.set("www.adjarabet.com", navigationEnabled)
        viewModel.subscribeTo(headerViewModel)
    }

    // MARK: Setup methods
    private func setup() {
        setBaseBackgroundColor(to: .primaryBg())
        setupWebView()
    }

    private func setupWebView() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.backgroundColor = .clear
        webView.isOpaque = false
        view.addSubview(webView)
        webView.pinSafely(to: webViewContainer)
    }

    // MARK: Action methods
    private func load(_ request: URLRequest) {
        webView.load(request as URLRequest)
    }

    private func load(_ html: String) {
        webView.loadHTMLString(html, baseURL: nil)
    }
}
