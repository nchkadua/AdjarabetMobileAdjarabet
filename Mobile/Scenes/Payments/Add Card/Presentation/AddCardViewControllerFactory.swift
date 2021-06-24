//
//  AddCardViewControllerFactory.swift
//  Mobile
//
//  Created by Nika Chkadua on 12/3/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

public protocol AddCardViewControllerFactory {
    func make(params: AddCardViewModelParams) -> AddCardViewController
}

public class DefaultAddCardViewControllerFactory: AddCardViewControllerFactory {
    public func make(params: AddCardViewModelParams) -> AddCardViewController {
        let vc = R.storyboard.addCard().instantiate(controller: AddCardViewController.self)!
        vc.viewModel = DefaultAddCardViewModel(params: params)
        return vc
    }
}
