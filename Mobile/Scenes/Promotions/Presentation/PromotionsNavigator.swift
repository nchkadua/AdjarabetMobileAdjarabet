//
//  PromotionsNavigator.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/2/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public class PromotionsNavigator: Navigator {
    @Inject(from: .factories) public var profileFactory: ProfileFactory
    @Inject(from: .factories) private var webViewControllerFactory: WebViewControllerFactory

    private weak var viewController: UIViewController?

    public init(viewController: UIViewController) {
        self.viewController = viewController
    }

    public enum Destination {
        case webView(params: WebViewModelParams)
    }

    public func navigate(to destination: Destination, animated animate: Bool) {
        switch destination {
        case .webView(let params): navigateToWebView(with: params, animate: animate)
        }
    }

    private func navigateToWebView(with params: WebViewModelParams, animate: Bool) {
        let vc = webViewControllerFactory.make(params: params)
//        let navc = vc.wrapInNavWith(presentationStyle: .automatic)
//        navc.navigationBar.styleForPrimaryPage()
//        viewController?.navigationController?.present(navc, animated: true, completion: nil)
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
