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
    @Inject(from: .viewModels) public var viewModel: WebViewModel
    public lazy var navigator = WebNavigator(viewController: self)
    private let disposeBag = DisposeBag()

    private lazy var webView: WKWebView = {
        WKWebView()
    }()

    @IBOutlet weak var wv: WKWebView!

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
        case .load(let url, let params): load(url, params)
        }
    }

    // MARK: Setup methods
    private func setup() {
        setBaseBackgorundColor(to: .primaryBg())
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
    private func load(_ url: String, _ params: [String: String]) {
        let url = URL(string: url)
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        var post = ""
        for (key, value) in params {
            post = key + "=" + value + "&"
        }

        let postData: Data = post.data(using: String.Encoding.ascii, allowLossyConversion: true)!

        request.httpBody = postData
        webView.load(request as URLRequest)
    }
}
