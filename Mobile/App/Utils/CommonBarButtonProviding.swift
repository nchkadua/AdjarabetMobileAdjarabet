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
        barButtonItem.button.setTitleColor(DesignSystem.Color.primaryText().value, for: .normal)
        barButtonItem.barButtonItem.isEnabled = false
        navigationItem.leftBarButtonItem = barButtonItem.barButtonItem
        return barButtonItem
    }

    @discardableResult
    func makeRightBarButtonItemTitle(to title: String) -> UIBarButtonItem.Coupled {
        let barButtonItem = UIBarButtonItem.make(title: title, typography: .footnote(fontCase: .lower))
        barButtonItem.button.setTitleColor(DesignSystem.Color.primaryText().value, for: .normal)
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
        button.setTitleColor(to: .primaryText(), for: .normal)
        button.setTintColor(to: .primaryText())
        button.semanticContentAttribute = .forceRightToLeft
        button.numberOfNotifications = number

        let titleButton = UIBarButtonItem.make(title: title, typography: .subHeadline(fontCase: .lower, fontStyle: .bold))
        titleButton.button.setTitleColor(DesignSystem.Color.primaryText().value, for: .normal)
        titleButton.barButtonItem.isEnabled = false
        titleButton.button.setTitle(R.string.localization.notifications_page_title.localized(), for: .normal)

        return [UIBarButtonItem(customView: button), titleButton.barButtonItem]
    }

    @discardableResult
    func userIdBarButtonItemGroup() -> UIBarButtonItem {
        let button = UserIdButton(type: .system)
        button.setFont(to: .body2(fontCase: .upper, fontStyle: .regular))
        button.setTitleColor(to: .primaryText(), for: .normal)
        button.setTintColor(to: .primaryText())
        button.semanticContentAttribute = .forceRightToLeft

        return UIBarButtonItem(customView: button)
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
    func makeCalendarBarButtonItem(width: CGFloat = 26) -> UIBarButtonItem.Coupled {
        let button = UIButton()
        button.setImage(R.image.transactionsHistory.calendar(), for: .normal)

        return (UIBarButtonItem(customView: button), button)
    }

    @discardableResult
    func makeAddCardBarButonItem(width: CGFloat = 26) -> UIBarButtonItem.Coupled {
        let button = UIButton()
        button.setImage(R.image.myCards.addCard(), for: .normal) // todo change icon to add
        return (UIBarButtonItem(customView: button), button)
    }

    @discardableResult
    func makeAccountParametersBarButtonItem(width: CGFloat = 26) -> UIBarButtonItem.Coupled {
        let button = UIButton()
        button.setTitle(R.string.localization.account_parameters.localized(), for: .normal)
        button.titleLabel?.textAlignment = .right
        button.setFont(to: .footnote(fontCase: .lower))
        button.widthAnchor.constraint(equalToConstant: width).isActive = true
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true

        return (UIBarButtonItem(customView: button), button)
    }

    @discardableResult
    func makeGameDepositBarButtonItem(width: CGFloat = 26) -> UIBarButtonItem.Coupled {
        let button = UIButton()
        button.setImage(R.image.game.deposit(), for: .normal)

        return (UIBarButtonItem(customView: button), button)
    }

    @discardableResult
    func makeBarrButtonWith(title: String) -> UIBarButtonItem.Coupled {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(DesignSystem.Color.primaryRed().value, for: .normal)
        button.setFont(to: .subHeadline(fontCase: .lower))
        return (UIBarButtonItem(customView: button), button)
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

    @discardableResult
    func makeBackBarButtonItem(width: CGFloat = 26) -> UIBarButtonItem.Coupled {
        let button = UIButton()
        button.setImage(R.image.shared.back(), for: .normal)
        button.titleLabel?.textAlignment = .center
        button.setFont(to: .subHeadline(fontCase: .lower, fontStyle: .semiBold))
        button.titleEdgeInsets = .init(top: 0, left: 8, bottom: 0, right: 0)
        button.setTitle(R.string.localization.profile_page_back_title.localized(), for: .normal)

        return (UIBarButtonItem(customView: button), button)
    }

    @discardableResult
    func makeRoundedBackButtonItem(width: CGFloat = 35, height: CGFloat = 35) -> UIBarButtonItem.Coupled {
        let button = UIButton()
        button.widthAnchor.constraint(equalToConstant: width).isActive = true
        button.heightAnchor.constraint(equalToConstant: height).isActive = true
        button.setImage(R.image.login.sms_back(), for: .normal)

        return (UIBarButtonItem(customView: button), button)
    }
}

public extension UIBarButtonItem {
    typealias Coupled = (barButtonItem: UIBarButtonItem, button: UIButton)
    static func make(title: String?, typography: DesignSystem.Typography = .footnote(fontCase: .lower)) -> Coupled {
        let button = UIButton(type: .system)
        button.setTitleWithoutAnimation(title, for: .normal)
        button.setFont(to: typography)
        button.setTitleColor(to: .primaryText(), for: .normal)

        let barButtonItem = UIBarButtonItem(customView: button)

        return (barButtonItem, button)
    }
}
