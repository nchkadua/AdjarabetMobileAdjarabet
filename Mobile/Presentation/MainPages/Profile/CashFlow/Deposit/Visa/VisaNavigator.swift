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

    func navigate(to destination: Destination) {
        switch destination {
        case .webView(let params): navigate2WebView(with: params)
        case .addAccount: navigate2AddAccount()
        }
    }

    private func navigate2WebView(with params: WebViewModelParams) {
        let vc = webViewFactory.make(params: params)
        let navC = vc.wrapInNavWith(presentationStyle: .automatic)
        navC.navigationBar.styleForPrimaryPage()
        viewController?.navigationController?.present(navC, animated: true, completion: nil)
    }

    private func navigate2AddAccount() {
        let vc = addAccountFactory.make(params: .init())
        let navc = vc.wrapInNavWith(presentationStyle: .automatic)
        navc.navigationBar.styleForPrimaryPage()
        viewController?.navigationController?.present(navc, animated: true, completion: nil)
    }
}
