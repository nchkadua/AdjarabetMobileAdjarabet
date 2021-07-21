//
//  FAQAnswersViewControllerFactory.swift
//  Mobile
//
//  Created by Nika Chkadua on 21.07.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

public protocol FAQAnswersViewControllerFactory {
    func make(params: FAQAnswersViewModelParams) -> FAQAnswersViewController
}

public class DefaultFAQAnswersViewControllerFactory: FAQAnswersViewControllerFactory {
    public func make(params: FAQAnswersViewModelParams) -> FAQAnswersViewController {
        let vc = R.storyboard.faqAnswers().instantiate(controller: FAQAnswersViewController.self)!
        vc.viewModel.params = params
        return vc
    }
}
