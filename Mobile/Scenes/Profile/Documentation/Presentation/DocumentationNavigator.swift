//
//  DocumentationNavigator.swift
//  Mobile
//
//  Created by Nika Chkadua on 06.07.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

public class DocumentationNavigator: Navigator {
    @Inject(from: .factories) private var webViewControllerFactory: WebViewControllerFactory
    private weak var viewController: UIViewController?

    public init(viewController: UIViewController) {
        self.viewController = viewController
    }

    public enum Destination {
        case termsAndConditions
        case privacyPolicy(with: WebViewModelParams)
    }

    public func navigate(to destination: Destination, animated animate: Bool) {
        switch destination {
        case .privacyPolicy(let params):
            navigateToWebView(with: params, animate: animate)
        case .termsAndConditions:
            break
        }
    }

    private func navigateToWebView(with params: WebViewModelParams, animate: Bool) {
        let vc = webViewControllerFactory.make(params: params)
        let navc = vc.wrapInNavWith(presentationStyle: .fullScreen)
        navc.navigationBar.styleForPrimaryPage()
        viewController?.navigationController?.present(navc, animated: true, completion: nil)
    }
}
