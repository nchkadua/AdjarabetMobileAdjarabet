//
//  VisaNavigator.swift
//  Mobile
//
//  Created by Nika Chkadua on 3/23/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

struct VisaNavigator {
    @Inject(from: .factories) private var webViewFactory: WebViewControllerFactory
    @Inject(from: .factories) private var addAccountFactory: AddCardViewControllerFactory

    private weak var viewController: UIViewController?

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    enum Destination {
        case webView(params: WebViewModelParams)
        case addAccount
    }

    func navigate(to destination: Destination, animated: Bool) {
        switch destination {
        case .webView(let params): navigate2WebView(with: params, animated: animated)
        case .addAccount: navigate2AddAccount(animated: animated)
        }
    }

    private func navigate2WebView(with params: WebViewModelParams, animated: Bool) {
        let vc = webViewFactory.make(params: params)
        let navC = vc.wrapInNavWith(presentationStyle: .automatic)
        navC.navigationBar.styleForPrimaryPage()
        viewController?.navigationController?.present(navC, animated: animated, completion: nil)
    }

    private func navigate2AddAccount(animated: Bool) {
        let vc = addAccountFactory.make(params: .init())
        let navc = vc.wrapInNavWith(presentationStyle: .automatic)
        navc.navigationBar.styleForPrimaryPage()
        viewController?.navigationController?.present(navc, animated: animated, completion: nil)
    }
}
