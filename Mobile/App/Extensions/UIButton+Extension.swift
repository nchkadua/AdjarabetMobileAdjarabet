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
}