//
//  DocumentationNavigator.swift
//  Mobile
//
//  Created by Nika Chkadua on 06.07.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

public class DocumentationNavigator: Navigator {
    private weak var viewController: UIViewController?

    public init(viewController: UIViewController) {
        self.viewController = viewController
    }

    public enum Destination {
        case termsAndConditions
        case confidential
    }

    public func navigate(to destination: Destination, animated animate: Bool) {
    }
}
