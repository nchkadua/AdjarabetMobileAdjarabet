//
//  BonusConditionNavigator.swift
//  Mobile
//
//  Created by Giga Khizanishvili on 04.10.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

public class BonusConditionNavigator: Navigator {
    private weak var viewController: UIViewController?

    public init(viewController: UIViewController) {
        self.viewController = viewController
    }

    public enum Destination {
		case back
    }

    public func navigate(to destination: Destination, animated animate: Bool) {
    }
}
