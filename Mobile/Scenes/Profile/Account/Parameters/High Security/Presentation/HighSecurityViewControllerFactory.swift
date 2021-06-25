//
//  HighSecurityViewControllerFactory.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 6/25/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

protocol HighSecurityViewControllerFactory {
    func make() -> HighSecurityViewController
}

struct DefaultHighSecurityViewControllerFactory: HighSecurityViewControllerFactory {
    func make() -> HighSecurityViewController {
        let vc = R.storyboard.highSecurity().instantiate(controller: HighSecurityViewController.self)!
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = vc
        return vc
    }
}
