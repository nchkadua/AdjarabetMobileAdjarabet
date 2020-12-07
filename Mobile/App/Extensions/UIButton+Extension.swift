//
//  UIButton+Extension.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/19/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public extension UIButton {
    enum ButtonImageAlignment {
        case left
        case right
    }

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

    func setButtonImage(_ image: UIImage, alignment: ButtonImageAlignment) {
        switch alignment {
        case .left: semanticContentAttribute = .forceLeftToRight
        case .right: semanticContentAttribute = .forceRightToLeft
        }

        setImage(image, for: .normal)
        imageEdgeInsets = .init(top: 0, left: 15, bottom: 0, right: 0)
    }
}
