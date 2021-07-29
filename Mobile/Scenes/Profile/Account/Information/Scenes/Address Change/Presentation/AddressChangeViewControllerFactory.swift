//
//  AddressChangeViewControllerFactory.swift
//  Mobile
//
//  Created by Nika Chkadua on 11/24/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public protocol AddressChangeViewControllerFactory {
    func make(params: AddressChangeViewModelParams) -> AddressChangeViewController
}

public class DefaultAddressChangeViewControllerFactory: AddressChangeViewControllerFactory {
    public func make(params: AddressChangeViewModelParams) -> AddressChangeViewController {
        let vc = R.storyboard.addressChange().instantiate(controller: AddressChangeViewController.self)!
        vc.viewModel.params = params
        return vc
    }
}
