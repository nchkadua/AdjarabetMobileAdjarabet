//
//  TermsAndConditionsViewControllerFactory.swift
//  Mobile
//
//  Created by Giga Khizanishvili on 30.07.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation
import Rswift

public protocol TermsAndConditionsViewControllerFactory {
    func make(params: TermsAndConditionsViewModelParams) -> TermsAndConditionsViewController
}

public class DefaultTermsAndConditionsViewControllerFactory: TermsAndConditionsViewControllerFactory {
    public func make(params: TermsAndConditionsViewModelParams) -> TermsAndConditionsViewController {
        let vc = R.storyboard.termsAndConditions().instantiate(controller: TermsAndConditionsViewController.self)!
        vc.viewModel.params = params
        return vc
    }
}
