//
//  FAQCategoriesViewControllerFactory.swift
//  Mobile
//
//  Created by Nika Chkadua on 20.07.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

public protocol FAQCategoriesViewControllerFactory {
    func make(params: FAQCategoriesViewModelParams) -> FAQCategoriesViewController
}

public class DefaultFAQCategoriesViewControllerFactory: FAQCategoriesViewControllerFactory {
    public func make(params: FAQCategoriesViewModelParams) -> FAQCategoriesViewController {
        let vc = R.storyboard.faqCategories().instantiate(controller: FAQCategoriesViewController.self)!
        vc.viewModel.params = params
        return vc
    }
}
