//
//  P2PTransferViewControllerFactory.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 11/18/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import UIKit

public protocol P2PTransferViewControllerFactory {
    func make() -> P2PTransferViewController
}

public class DefaultP2PTransferViewControllerFactory: P2PTransferViewControllerFactory {
    public func make() -> P2PTransferViewController {
        R.storyboard.p2PTransferView().instantiate(controller: P2PTransferViewController.self)!
    }
}
