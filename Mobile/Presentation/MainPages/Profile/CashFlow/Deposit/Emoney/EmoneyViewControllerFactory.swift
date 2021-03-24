//
//  EmoneyViewControllerFactory.swift
//  Mobile
//
//  Created by Nika Chkadua on 3/23/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

protocol EmoneyViewControllerFactory {
    func make() -> EmoneyViewController
}

struct DefaultEmoneyViewControllerFactory: EmoneyViewControllerFactory {
    func make() -> EmoneyViewController {
        return R.storyboard.emoney().instantiate(controller: EmoneyViewController.self)!
    }
}
