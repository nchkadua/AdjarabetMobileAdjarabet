//
//  ApplePayViewControllerFactory.swift
//  Mobile
//
//  Created by Nika Chkadua on 4/7/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

public protocol ApplePayViewControllerFactory {
    func make() -> ApplePayViewController
}

public class DefaultApplePayViewControllerFactory: ApplePayViewControllerFactory {
    public func make() -> ApplePayViewController {
        let vc = R.storyboard.applePay().instantiate(controller: ApplePayViewController.self)!
        return vc
    }
}
