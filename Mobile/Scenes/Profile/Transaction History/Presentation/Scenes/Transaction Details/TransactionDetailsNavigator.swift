//
//  TransactionDetailsNavigator.swift
//  Mobile
//
//  Created by Irakli Shelia on 11/19/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public class TransactionDetailsNavigator: Navigator {
    private weak var viewController: UIViewController?

    public init(viewController: UIViewController) {
        self.viewController = viewController
    }

    public enum Destination {
    }

    public func navigate(to destination: Destination, animated animate: Bool) {
    }
}
