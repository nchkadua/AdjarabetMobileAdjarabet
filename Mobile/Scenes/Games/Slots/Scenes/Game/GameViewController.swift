//
//  GameViewController.swift
//  Mobile
//
//  Created by Nika Chkadua on 2/8/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift
import WebKit

class GameViewController: ABViewController {
    var viewModel: GameViewModel!
    private lazy var navigator = GameNavigator(viewController: self)
    // Views
    @IBOutlet private weak var gameLoaderView: GameLoaderComponentView!
    private lazy var webView = WKWebView()

    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.viewDidDisappear()
    }

    // MARK: Bind to viewModel's observable properties
    private func bind(to viewModel: GameViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)
    }

    private func didRecive(action: GameViewModelOutputAction) {
        switch action {
        case .bindToGameLoader(let viewModel): bindToGameLoader(viewModel)
        case .load(let url): webView.load(URLRequest(url: url))
        case .show(let error): showAlert(title: error) { [weak self] _ in self?.dismissGameView() }
        }
    }

    /// CashFlow Tab
    private func bindToGameLoader(_ gameLoaderViewModel: GameLoaderComponentViewModel) {
        gameLoaderView.setAndBind(viewModel: gameLoaderViewModel)
        bind(to: gameLoaderViewModel)
    }

    private func bind(to viewModel: GameLoaderComponentViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)
    }

    private func didRecive(action: GameLoaderComponentViewModelOutputAction) {
        switch action {
        case .didBeginAnimation: print("Animation did begin")
        case .didFinishAnimation: print("Animation did finish")
        default:
            break
        }
    }

    // MARK: Setup methods
    private func setup() {
        setBaseBackgorundColor(to: .primaryBg())
        setupNavigationItems()
        setupWebView()
    }

    private func setupNavigationItems() {
     // setTitle(title: "თამაშის სათაური")
        setGameBackButton(width: 54)
        let depositButton = makeGameDepositBarButtonItem()
        navigationItem.rightBarButtonItem = depositButton.barButtonItem
        depositButton.button.addTarget(self, action: #selector(openDeposit), for: .touchUpInside)
    }

    @objc private func openDeposit() {
        navigator.navigate(to: .deposit, animated: true)
    }

    private func setupWebView() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.backgroundColor = .clear
        webView.isOpaque = false

        webView.configuration.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")
        webView.configuration.setValue("TRUE", forKey: "allowUniversalAccessFromFileURLs")
        webView.configuration.preferences.javaScriptEnabled = true
        webView.navigationDelegate = self

        view.addSubview(webView)
        webView.pinSafely(to: view)
    }
}

extension GameViewController: CommonBarButtonProviding { }

// MARK: - GameViewController Navigation Items
extension GameViewController {
    private func setGameBackButton(width: CGFloat = 26) {
        navigationItem.leftBarButtonItems?.removeAll()
        let button = UIButton()
        button.setImage(R.image.game.back(), for: .normal)
        button.widthAnchor.constraint(equalToConstant: width).isActive = true
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.addTarget(self, action: #selector(dismissGameView), for: .touchUpInside)
        let backBarButtonItem = UIBarButtonItem(customView: button)
        navigationItem.leftBarButtonItem = backBarButtonItem
    }

    @objc private func dismissGameView() {
        dismiss(animated: true, completion: nil)
    }
}

extension GameViewController: WKNavigationDelegate {
    public func webView(_ webView: WKWebView,
                        decidePolicyFor navigationAction: WKNavigationAction,
                        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }

    public func webView(_ webView: WKWebView,
                        didReceive challenge: URLAuthenticationChallenge,
                        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void) {
        if let trust = challenge.protectionSpace.serverTrust {
            completionHandler(.useCredential, URLCredential(trust: trust))
        } else {
            completionHandler(.performDefaultHandling, nil)
        }
    }
}
