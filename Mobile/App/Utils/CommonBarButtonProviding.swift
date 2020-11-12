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
        let barButtonItem = UIBarButtonItem.make(title: title, typography: .title3(fontCase: .lower))
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
        let loginBarButtonItem = UIBarButtonItem.make(title: R.string.localization.login.localized())
        navigationItem.rightBarButtonItems = [loginBarButtonItem.barButtonItem]
        return loginBarButtonItem
    }

    @discardableResult
    func notificationsBarButtonItemGroupWith(numberOfNotifications number: Int) -> [UIBarButtonItem] {
        let button = NotificationsButton(type: .system)
        button.setFont(to: .subHeadline(fontCase: .upper, fontStyle: .bold))
        button.setTitleColor(to: .systemWhite(), for: .normal)
        button.setTintColor(to: .systemWhite())
        button.semanticContentAttribute = .forceRightToLeft
        button.numberOfNotifications = number

        let titleButton = UIBarButtonItem.make(title: title, typography: .subHeadline(fontCase: .lower, fontStyle: .bold))
        titleButton.button.setTitleColor(DesignSystem.Color.systemWhite().value, for: .normal)
        titleButton.barButtonItem.isEnabled = false
        titleButton.button.setTitle(R.string.localization.notifications_page_title(), for: .normal)

        return [UIBarButtonItem(customView: button), titleButton.barButtonItem]
    }

    @discardableResult
    func makeBalanceBarButtonItem() -> UIBarButtonItem.Coupled {
        let button = BalanceProfileButton(type: .system)
        button.setFont(to: .footnote(fontCase: .upper, fontStyle: .semiBold))
        button.setTitleColor(to: .primaryText(), for: .normal)
        button.setTintColor(to: .primaryText())
        button.setImage(R.image.shared.navBar.profile()?.resizeImage(newHeight: 20), for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.titleEdgeInsets = UIEdgeInsets(top: 4, left: -8, bottom: 0, right: 0)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)

        return (UIBarButtonItem(customView: button), button)
    }

    @discardableResult
    func makeSettingsBarButtonItem(width: CGFloat = 26) -> UIBarButtonItem {
        let button = UIButton()
        button.setImage(R.image.notifications.settings(), for: .normal)
        button.widthAnchor.constraint(equalToConstant: width).isActive = true
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        let settingsBarButtonItem = UIBarButtonItem(customView: button)

        return settingsBarButtonItem
    }

    @discardableResult
    func makeAdjarabetLogo() -> UIBarButtonItem {
        let logoImageView = UIImageView(image: R.image.login.logo())
        logoImageView.frame = CGRect(x: 0, y: 0, width: 155, height: 19)
        logoImageView.contentMode = .scaleAspectFit
        let logoImageItem = UIBarButtonItem(customView: logoImageView)
        navigationItem.leftBarButtonItem = logoImageItem

        return logoImageItem
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
