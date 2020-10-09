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
    func makeLeftBarButtonItemTitle(to title: String) -> UIBarButtonItem.Coupled {
        let barButtonItem = UIBarButtonItem.make(title: title, typography: .h2(fontCase: .lower))
        barButtonItem.button.setTitleColor(DesignSystem.Color.systemWhite().value, for: .normal)
        barButtonItem.barButtonItem.isEnabled = false
        navigationItem.leftBarButtonItem = barButtonItem.barButtonItem
        return barButtonItem
    }

    @discardableResult
    func makeRightBarButtonItemTitle(to title: String) -> UIBarButtonItem.Coupled {
        let barButtonItem = UIBarButtonItem.make(title: title, typography: .h3(fontCase: .lower))
        barButtonItem.button.setTitleColor(DesignSystem.Color.systemWhite().value, for: .normal)
        barButtonItem.barButtonItem.isEnabled = false
        navigationItem.rightBarButtonItem = barButtonItem.barButtonItem
        return barButtonItem
    }

    @discardableResult
    func makeLoginBarButtonItem() -> UIBarButtonItem.Coupled {
//        let joinNowBarButtonItem = UIBarButtonItem.make(title: R.string.localization.join_now.localized())
        let loginBarButtonItem = UIBarButtonItem.make(title: R.string.localization.login.localized())
        navigationItem.rightBarButtonItems = [loginBarButtonItem.barButtonItem]
        return loginBarButtonItem
    }

    @discardableResult
    func makeBalanceBarButtonItem() -> UIBarButtonItem.Coupled {
        let button = BalanceProfileButton(type: .system)
        button.setFont(to: .h4(fontCase: .lower))
        button.setTitleColor(to: .systemWhite(), for: .normal)
        button.setTintColor(to: .systemWhite())
        button.setImage(R.image.shared.navBar.profile()?.resizeImage(newHeight: 20), for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.titleEdgeInsets = UIEdgeInsets(top: 4, left: -8, bottom: 0, right: 0)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)

        return (UIBarButtonItem(customView: button), button)
    }
}

public extension UIBarButtonItem {
    typealias Coupled = (barButtonItem: UIBarButtonItem, button: UIButton)
    static func make(title: String?, typography: DesignSystem.Typography = .h4(fontCase: .lower)) -> Coupled {
        let button = UIButton(type: .system)
        button.setTitleWithoutAnimation(title, for: .normal)
        button.setFont(to: typography)
        button.setTitleColor(to: .separator(), for: .normal)

        let barButtonItem = UIBarButtonItem(customView: button)

        return (barButtonItem, button)
    }
}
