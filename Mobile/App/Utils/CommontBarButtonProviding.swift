//
//  CommontBarButtonProviding.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/14/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

public protocol CommontBarButtonProviding: UIViewController { }

public extension CommontBarButtonProviding {
    @discardableResult
    func setLeftBarButtonItemTitle(to title: String) -> UIBarButtonItem.Coupled {
        let barButtonItem = UIBarButtonItem.make(title: "Games", typography: .h1)
        barButtonItem.barButtonItem.isEnabled = false
        navigationItem.leftBarButtonItem = barButtonItem.barButtonItem
        return barButtonItem
    }

    @discardableResult
    func setAuthBarButtonItems() -> (joinNow: UIBarButtonItem.Coupled, login: UIBarButtonItem.Coupled) {
        let joinNowBarButtonItem = UIBarButtonItem.make(title: "Join Now")
        let loginBarButtonItem = UIBarButtonItem.make(title: "Login")
        navigationItem.rightBarButtonItems = [loginBarButtonItem.barButtonItem, joinNowBarButtonItem.barButtonItem]
        return (joinNowBarButtonItem, loginBarButtonItem)
    }
}

public extension UIBarButtonItem {
    typealias Coupled = (barButtonItem: UIBarButtonItem, button: UIButton)
    static func make(title: String, typography: DesignSystem.Typography = .h4) -> Coupled {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = typography.description.font
        button.setTitleColor(DesignSystem.Color.neutral100, for: .normal)

        let barButtonItem = UIBarButtonItem(customView: button)

        return (barButtonItem, button)
    }
}
