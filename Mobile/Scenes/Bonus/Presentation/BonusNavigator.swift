//
//  BonusNavigator.swift
//  Mobile
//
//  Created by Nika Chkadua on 4/26/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

class BonusNavigator: Navigator {
    private weak var viewController: UIViewController?

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    enum Destination {
    }

    func navigate(to destination: Destination, animated animate: Bool) {
    }
}
