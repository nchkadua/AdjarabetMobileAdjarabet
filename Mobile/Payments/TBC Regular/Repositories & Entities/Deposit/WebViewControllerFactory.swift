//
//  WebViewControllerFactory.swift
//  Mobile
//
//  Created by Nika Chkadua on 3/10/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

public protocol WebViewControllerFactory {
    func make(params: WebViewModelParams) -> WebViewController
}

public class DefaultWebViewControllerFactory: WebViewControllerFactory {
    public func make(params: WebViewModelParams) -> WebViewController {
        let vc = R.storyboard.web().instantiate(controller: WebViewController.self)!
        vc.viewModel.params = params
        return vc
    }
}
