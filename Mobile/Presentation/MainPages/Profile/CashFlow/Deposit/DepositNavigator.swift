//
//  DepositNavigator.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/28/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public class DepositNavigator: Navigator {
    @Inject(from: .factories) public var addCardViewControllerFactory: AddCardViewControllerFactory
    @Inject(from: .factories) public var webViewControllerFactory: WebViewControllerFactory

    private weak var viewController: UIViewController?

    public init(viewController: UIViewController) {
        self.viewController = viewController
    }

    public enum Destination {
        case addCard
        case webView(params: WebViewModelParams)
    }

    public func navigate(to destination: Destination, animated animate: Bool) {
        switch destination {
        case .addCard: navigateToAddCard(animate: animate)
        case .webView(let params): navigateToWebView(with: params, animate: animate)
        }
    }

    private func navigateToAddCard(animate: Bool) {
        let vc = addCardViewControllerFactory.make(params: .init())
        let navC = vc.wrapInNavWith(presentationStyle: .automatic)
        navC.navigationBar.styleForPrimaryPage()
        viewController?.navigationController?.present(navC, animated: animate, completion: nil)
    }

    private func navigateToWebView(with params: WebViewModelParams, animate: Bool) {
        let vc = webViewControllerFactory.make(params: .init(url: params.url, params: params.params))
        let navC = vc.wrapInNavWith(presentationStyle: .automatic)
        navC.navigationBar.styleForPrimaryPage()
        viewController?.navigationController?.present(navC, animated: animate, completion: nil)
    }
}
