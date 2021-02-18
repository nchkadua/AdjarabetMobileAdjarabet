//
//  SportViewController.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/14/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import UIKit
import WebKit
import SafariServices

public class SportsViewController: UIViewController {
    public override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    var result: GameLaunchUrlResult!
    let interactor: GameLaunchInteractor = DefaultGameLaunchInteractor()

    private lazy var webView = WKWebView()

    public override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        getLaunchUrl()
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    // MARK: Setup methods
    private func setup() {
        setBaseBackgorundColor()
        makeAdjarabetLogo()
        navigationItem.rightBarButtonItem = makeBalanceBarButtonItem().barButtonItem
        setupWebView()
    }

    private func initWebServer(_ launchUrl: URL) {
        webView.load(URLRequest(url: launchUrl))
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

extension SportsViewController: CommonBarButtonProviding { }

extension SportsViewController {
    func getLaunchUrl() {
        interactor.launch(gameId: "7463", providerId: "11e7b7ca-14f1-b0b0-88fc-005056adb106") { [weak self] (result) in
            switch result {
            case .success(let launchUrl):
                self?.result = launchUrl
                self?.initWebServer(launchUrl.url)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension SportsViewController: WKNavigationDelegate {

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
