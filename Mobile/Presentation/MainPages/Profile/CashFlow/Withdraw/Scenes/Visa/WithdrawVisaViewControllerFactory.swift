//
//  WithdrawVisaViewControllerFactory.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 4/5/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

protocol WithdrawVisaViewControllerFactory {
    func make(with params: WithdrawVisaViewModelParams) -> WithdrawVisaViewController
}

struct DefaultWithdrawVisaViewControllerFactory: WithdrawVisaViewControllerFactory {
    func make(with params: WithdrawVisaViewModelParams) -> WithdrawVisaViewController {
        let vc = R.storyboard.withdrawVisa().instantiate(controller: WithdrawVisaViewController.self)!
        vc.viewModel = DefaultWithdrawVisaViewModel(with: params)
        return vc
    }
}
