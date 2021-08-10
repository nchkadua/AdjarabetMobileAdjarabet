//
//  BonusViewControllerFactory.swift
//  Mobile
//
//  Created by Nika Chkadua on 4/26/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

protocol BonusViewControllerFactory {
    func make(params: BonusViewModelParams) -> BonusViewController
}

class DefaultBonusViewControllerFactory: BonusViewControllerFactory {
    func make(params: BonusViewModelParams) -> BonusViewController {
        let vc = R.storyboard.bonus().instantiate(controller: BonusViewController.self)!
        vc.viewModel.params = params
        return vc
    }
}
