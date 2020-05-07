//
//  UIButton+Extension.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/19/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public extension UIButton {
    func setTitleColor(to color: DesignSystem.Color?, for state: UIControl.State, alpha: CGFloat = 1) {
        self.setTitleColor(color?.value.withAlphaComponent(alpha), for: state)
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

public extension ABButton {
    func set(size: DesignSystem.Button.Size) {
        setFont(to: size.description.typograhy)
        contentEdgeInsets = size.description.contentEdgeInsets
    }

    func set(style: DesignSystem.Button.Style) {
        let description = style.description

        setTitleColor(to: description.textColor.color, for: .normal, alpha: description.textColor.alpha)

        self.backgroundColor = description.blended
        self.borderWidth = description.borderWidth
        self.borderColor = description.borderColor?.caclulated ?? .clear
        self.cornerRadius = 4
    }
}
