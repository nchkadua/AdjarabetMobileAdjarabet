//
//  FAQAnswersNavigator.swift
//  Mobile
//
//  Created by Nika Chkadua on 21.07.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

public class FAQAnswersNavigator: Navigator {
    private weak var viewController: UIViewController?

    public init(viewController: UIViewController) {
        self.viewController = viewController
    }

    public enum Destination {
    }

    public func navigate(to destination: Destination, animated animate: Bool) {
    }
}
