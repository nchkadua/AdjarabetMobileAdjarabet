//
//  GameViewControllerFactory.swift
//  Mobile
//
//  Created by Nika Chkadua on 2/8/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

protocol GameViewControllerFactory {
    func make(params: GameViewModelParams) -> GameViewController
}

struct DefaultGameViewControllerFactory: GameViewControllerFactory {
    func make(params: GameViewModelParams) -> GameViewController {
        let vc = R.storyboard.game().instantiate(controller: GameViewController.self)!
        vc.viewModel = DefaultGameViewModel(params: params)
        return vc
    }
}
