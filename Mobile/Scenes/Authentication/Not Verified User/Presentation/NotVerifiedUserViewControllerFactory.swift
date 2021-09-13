//
//  NotVerifiedUserViewControllerFactory.swift
//  Mobile
//
//  Created by Nika Chkadua on 13.09.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

public protocol NotVerifiedUserViewControllerFactory {
    func make(params: NotVerifiedUserViewModelParams) -> NotVerifiedUserViewController
}

public class DefaultNotVerifiedUserViewControllerFactory: NotVerifiedUserViewControllerFactory {
    public func make(params: NotVerifiedUserViewModelParams) -> NotVerifiedUserViewController {
        let vc = R.storyboard.notVerifiedUser().instantiate(controller: NotVerifiedUserViewController.self)!
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = vc
        vc.viewModel.params = params
        return vc
    }
}
