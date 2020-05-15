//
//  HomeNavigator.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 5/15/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public class HomeNavigator: Navigator {
    private weak var viewController: UIViewController?

    public init(viewController: UIViewController) {
        self.viewController = viewController
    }

    public enum Destination {
    }

    public func navigate(to destination: Destination, animated animate: Bool) {
    }
}
