//
//  DocumentationViewControllerFactory.swift
//  Mobile
//
//  Created by Nika Chkadua on 06.07.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

public protocol DocumentationViewControllerFactory {
    func make(params: DocumentationViewModelParams) -> DocumentationViewController
}

public class DefaultDocumentationViewControllerFactory: DocumentationViewControllerFactory {
    public func make(params: DocumentationViewModelParams) -> DocumentationViewController {
        let vc = R.storyboard.documentation().instantiate(controller: DocumentationViewController.self)!
        vc.viewModel.params = params
        return vc
    }
}
