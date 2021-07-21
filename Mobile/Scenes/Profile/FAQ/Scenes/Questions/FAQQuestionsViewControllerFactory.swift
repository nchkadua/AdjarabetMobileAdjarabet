//
//  FAQQuestionsViewControllerFactory.swift
//  Mobile
//
//  Created by Nika Chkadua on 20.07.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

public protocol FAQQuestionsViewControllerFactory {
    func make(params: FAQQuestionsViewModelParams) -> FAQQuestionsViewController
}

public class DefaultFAQQuestionsViewControllerFactory: FAQQuestionsViewControllerFactory {
    public func make(params: FAQQuestionsViewModelParams) -> FAQQuestionsViewController {
        let vc = R.storyboard.faqQuestions().instantiate(controller: FAQQuestionsViewController.self)!
        vc.viewModel.params = params
        return vc
    }
}
