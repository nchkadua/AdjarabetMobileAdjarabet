//
//  GameViewControllerFactory.swift
//  Mobile
//
//  Created by Nika Chkadua on 2/8/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

public protocol GameViewControllerFactory {
    func make(params: GameViewModelParams) -> GameViewController
}

public class DefaultGameViewControllerFactory: GameViewControllerFactory {
    public func make(params: GameViewModelParams) -> GameViewController {
        let vc = R.storyboard.game().instantiate(controller: GameViewController.self)!
        vc.viewModel.params = params
        return vc
    }
}
