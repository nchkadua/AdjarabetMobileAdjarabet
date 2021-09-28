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
    @IBOutlet weak var headerComponentView: WebViewHeaderComponentView!
    

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
        case .bindToGridViewModel(let viewModel): bind(to: viewModel)
        }
    }
    
    /// Header
    private func bindToGrid(_ viewModel: WebViewHeaderComponentViewModel) {
        headerComponentView.setAndBind(viewModel: viewModel)
        bind(to: viewModel)
    }

    private func bind(to viewModel: WebViewHeaderComponentViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)
    }

    private func didRecive(action: WebViewHeaderComponentViewModelOutputAction) {
        switch action {
        case .dismiss: dismiss(animated: true, completion: nil)
        case .goBack: webView.goBack()
        case .goForward: webView.goForward()
        case .refresh: webView.reload()
        default:
            break
        }
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
        webView.pinSafely(to: view)
    }

    // MARK: Action methods
    private func load(_ request: URLRequest) {
        webView.load(request as URLRequest)
    }

    private func load(_ html: String) {
        webView.loadHTMLString(html, baseURL: nil)
    }
}
