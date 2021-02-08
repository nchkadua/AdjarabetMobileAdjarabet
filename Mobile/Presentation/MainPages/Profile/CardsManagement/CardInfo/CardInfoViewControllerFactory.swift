//
//  CardInfoViewControllerFactory.swift
//  Mobile
//
//  Created by Nika Chkadua on 2/5/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
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
