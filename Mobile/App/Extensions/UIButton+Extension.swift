//
//  UIButton+Extension.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/19/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public extension UIButton {
    func setTitleColor(to color: DesignSystem.Color?, for state: UIControl.State) {
        self.setTitleColor(color?.value, for: state)
    }

    func setFont(to typography: DesignSystem.Typography) {
        self.titleLabel?.font = typography.description.font
    }

    func setTitleWithoutAnimation(_ title: String?, for state: UIControl.State) {
        UIView.performWithoutAnimation {
            setTitle(title, for: state)
            layoutIfNeeded()
        }
    }

    func setAttributedTitleWithoutAnimation(_ title: NSAttributedString?, for state: UIControl.State) {
        UIView.performWithoutAnimation {
            setAttributedTitle(title, for: state)
            layoutIfNeeded()
        }
    }
}

public extension AppCircularButton {
    func set(size: DesignSystem.Button.Size) {
        setFont(to: size.description.typograhy)
        contentEdgeInsets = size.description.contentEdgeInsets
    }

    func set(style: DesignSystem.Button.Style) {
        let description = style.description

        setTitleColor(to: description.textColor, for: .normal)

        self.backgroundColor = description.blended
        self.borderWidth = description.borderWidth
        self.borderColor = description.borderColor?.value ?? .clear
        self.cornerRadius = description.cornerRadius
    }
}
