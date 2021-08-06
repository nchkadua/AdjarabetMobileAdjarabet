//
//  TermsAndConditionsNavigator.swift
//  Mobile
//
//  Created by Giga Khizanishvili on 30.07.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

public class TermsAndConditionsNavigator: Navigator {
    private weak var viewController: UIViewController?

    public init(viewController: UIViewController) {
        self.viewController = viewController
    }

    public enum Destination {
    }

    public func navigate(to destination: Destination, animated animate: Bool) {
    }
}
