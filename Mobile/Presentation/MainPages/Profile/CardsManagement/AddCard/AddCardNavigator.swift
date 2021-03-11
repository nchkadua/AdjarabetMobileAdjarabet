//
//  AddCardNavigator.swift
//  Mobile
//
//  Created by Nika Chkadua on 12/3/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public class AddCardNavigator: Navigator {
    @Inject(from: .factories) public var cardInfoViewControllerFactory: CardInfoViewControllerFactory
    @Inject(from: .factories) public var webViewControllerFactory: WebViewControllerFactory

    private weak var viewController: UIViewController?

    public init(viewController: UIViewController) {
        self.viewController = viewController
    }

    public enum Destination {
        case cardInfo(params: CardInfoViewModelParams)
        case webView(params: WebViewModelParams)
    }

    public func navigate(to destination: Destination, animated animate: Bool) {
        switch destination {
        case .cardInfo(let params): navigateToCardInfo(params: params, animated: animate)
        case .webView(let params): navigateToWebView(with: params, animate: animate)
        }
    }

    private func navigateToCardInfo(params: CardInfoViewModelParams, animated: Bool) {
        let vc = cardInfoViewControllerFactory.make(params: params)
        viewController?.navigationController?.pushViewController(vc, animated: animated)
    }

    private func navigateToWebView(with params: WebViewModelParams, animate: Bool) {
        let vc = webViewControllerFactory.make(params: .init(url: params.url, params: params.params))
        let navC = vc.wrapInNavWith(presentationStyle: .automatic)
        navC.navigationBar.styleForPrimaryPage()
        viewController?.navigationController?.present(navC, animated: animate, completion: nil)
    }
}
