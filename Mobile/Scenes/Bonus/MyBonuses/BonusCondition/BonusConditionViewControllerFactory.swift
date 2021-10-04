//
//  BonusConditionViewControllerFactory.swift
//  Mobile
//
//  Created by Giga Khizanishvili on 04.10.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

public protocol BonusConditionViewControllerFactory {
    func make(params: BonusConditionViewModelParams) -> BonusConditionViewController
}

public class DefaultBonusConditionViewControllerFactory: BonusConditionViewControllerFactory {
    public func make(params: BonusConditionViewModelParams) -> BonusConditionViewController {
        let vc = R.storyboard.bonusCondition().instantiate(controller: BonusConditionViewController.self)!

		vc.modalPresentationStyle = .custom
		vc.transitioningDelegate = vc
		vc.viewModel.params = params
        return vc
    }
}
