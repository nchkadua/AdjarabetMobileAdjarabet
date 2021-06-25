//
//  HighSecurityNavigator.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 6/25/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

struct HighSecurityNavigator {
    private weak var viewController: UIViewController?

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    enum Destination {
    }

    func navigate(to destination: Destination) {
    }
}
