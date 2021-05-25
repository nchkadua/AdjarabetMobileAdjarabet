//
//  EmoneyNavigator.swift
//  Mobile
//
//  Created by Nika Chkadua on 3/23/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

struct EmoneyNavigator {
    @Inject(from: .factories) private var webViewControllerFactory: WebViewControllerFactory
    private weak var viewController: UIViewController?

    @Inject(from: .factories) private var f: VisaViewControllerFactory

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    enum Destination {
        case webView(with: WebViewModelParams)
    }

    func navigate(to destination: Destination) {
        switch destination {
        case .webView(let params):
            navigateToWebView(with: params)
        }
    }

    private func navigateToWebView(with params: WebViewModelParams) {
        let vc = webViewControllerFactory.make(params: params)
        let navc = vc.wrapInNavWith(presentationStyle: .automatic)
        navc.navigationBar.styleForPrimaryPage()
        viewController?.navigationController?.present(navc, animated: true, completion: nil)
    }
}
