//
//  CommontBarButtonProviding.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/14/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

public protocol CommonBarButtonProviding: UIViewController { }

public extension CommonBarButtonProviding {
    @discardableResult
    func setLeftBarButtonItemTitle(to title: String) -> UIBarButtonItem.Coupled {
        let barButtonItem = UIBarButtonItem.make(title: title, typography: .h1(fontCase: .lower))
        barButtonItem.barButtonItem.isEnabled = false
        navigationItem.leftBarButtonItem = barButtonItem.barButtonItem
        return barButtonItem
    }

    @discardableResult
    func setLoginBarButtonItem() -> UIBarButtonItem.Coupled {
//        let joinNowBarButtonItem = UIBarButtonItem.make(title: R.string.localization.join_now.localized())
        let loginBarButtonItem = UIBarButtonItem.make(title: R.string.localization.login.localized())
        navigationItem.rightBarButtonItems = [loginBarButtonItem.barButtonItem]
        return loginBarButtonItem
    }

    @discardableResult
    func setProfileBarButtonItem(text: String? = nil) -> UIBarButtonItem.Coupled {
        let priceBarButtonItem = UIBarButtonItem.make(title: text)
        priceBarButtonItem.button.setImage(R.image.shared.navBar.profile()?.resizeImage(newHeight: 20), for: .normal)
        priceBarButtonItem.button.semanticContentAttribute = .forceRightToLeft
        priceBarButtonItem.button.titleEdgeInsets = UIEdgeInsets(top: 4, left: -8, bottom: 0, right: 0)
        navigationItem.rightBarButtonItems = [priceBarButtonItem.barButtonItem]
        return priceBarButtonItem
    }
}

public extension UIBarButtonItem {
    typealias Coupled = (barButtonItem: UIBarButtonItem, button: UIButton)
    static func make(title: String?, typography: DesignSystem.Typography = .h4(fontCase: .lower)) -> Coupled {
        let button = UIButton(type: .system)
        button.setTitleWithoutAnimation(title, for: .normal)
        button.setFont(to: typography)
        button.setTitleColor(to: .neutral100, for: .normal)

        let barButtonItem = UIBarButtonItem(customView: button)

        return (barButtonItem, button)
    }
}
