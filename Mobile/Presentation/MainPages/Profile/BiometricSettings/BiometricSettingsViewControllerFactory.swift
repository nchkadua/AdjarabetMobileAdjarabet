//
//  BiometricSettingsViewControllerFactory.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 11/17/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import UIKit

public protocol BiometricSettingsViewControllerFactory {
    func make() -> BiometricSettingsViewController
}

public class DefaultBiometricSettingsViewControllerFactory: BiometricSettingsViewControllerFactory {
    public func make() -> BiometricSettingsViewController {
        let vc = BiometricSettingsViewController()
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = vc
        return vc
    }
}
