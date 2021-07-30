//
//  DocumentationNavigator.swift
//  Mobile
//
//  Created by Nika Chkadua on 06.07.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

public class DocumentationNavigator: Navigator {
    @Inject(from: .factories) private var webViewControllerFactory: WebViewControllerFactory
    @Inject(from: .factories) private var termsAndConditionsControllerFactory: TermsAndConditionsViewControllerFactory
    private weak var viewController: UIViewController?

    public init(viewController: UIViewController) {
        self.viewController = viewController
    }

    public enum Destination {
        case termsAndConditions(with: TermsAndConditionsViewModelParams)
        case privacyPolicy(with: WebViewModelParams)
    }

    public func navigate(to destination: Destination, animated animate: Bool) {
        switch destination {
        case .privacyPolicy(let params):
            navigateToWebView(with: params, animate: animate)
        case .termsAndConditions(let params):
            navigateToTermsAndConditions(with: params, animate: animate)
        }
    }
    
    private func navigateToTermsAndConditions(with params: TermsAndConditionsViewModelParams, animate: Bool) {
        print("Terms and Conditions")
        let vc = termsAndConditionsControllerFactory.make(params: params)
        let navC = vc.wrapInNavWith(presentationStyle: .automatic)
        navC.navigationBar.styleForPrimaryPage()
        viewController?.navigationController?.present(navC, animated: animate)
    }

    private func navigateToWebView(with params: WebViewModelParams, animate: Bool) {
        let vc = webViewControllerFactory.make(params: params)
        let navc = vc.wrapInNavWith(presentationStyle: .fullScreen)
        navc.navigationBar.styleForPrimaryPage()
        viewController?.navigationController?.present(navc, animated: true, completion: nil)
    }
}
