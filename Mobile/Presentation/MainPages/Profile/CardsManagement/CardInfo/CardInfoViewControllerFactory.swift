//
//  CardInfoViewControllerFactory.swift
//  Mobile
//
//  Created by Nika Chkadua on 12/3/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

public protocol CardInfoViewControllerFactory {
    func make(params: CardInfoViewModelParams) -> CardInfoViewController
}

public class DefaultCardInfoViewControllerFactory: CardInfoViewControllerFactory {
    public func make(params: CardInfoViewModelParams) -> CardInfoViewController {
        let vc = R.storyboard.cardInfo().instantiate(controller: CardInfoViewController.self)!
        vc.viewModel.params = params
        return vc
    }
}
