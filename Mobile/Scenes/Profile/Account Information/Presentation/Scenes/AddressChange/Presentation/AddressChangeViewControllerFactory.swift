//
//  AddressChangeViewControllerFactory.swift
//  Mobile
//
//  Created by Nika Chkadua on 11/24/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public protocol AddressChangeViewControllerFactory {
    func make() -> AddressChangeViewController
}

public class DefaultAddressChangeViewControllerFactory: AddressChangeViewControllerFactory {
    public func make() -> AddressChangeViewController {
        R.storyboard.addressChange().instantiate(controller: AddressChangeViewController.self)!
    }
}
