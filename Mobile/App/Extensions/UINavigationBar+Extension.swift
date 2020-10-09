//
//  UINavigationBar+Extension.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/9/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public extension UINavigationBar {
    func styleForPrimaryPage() {
        setBackgroundImage(UIImage(), for: .default)
        shadowImage = UIImage()
        isTranslucent = false
        barTintColor = DesignSystem.Color.baseBg150().value
    }

    func styleForSecondaryPage() {
        isTranslucent = false
        barTintColor = DesignSystem.Color.baseBg300().value
    }
}
