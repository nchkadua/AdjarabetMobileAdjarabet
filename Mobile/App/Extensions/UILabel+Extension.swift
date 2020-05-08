//
//  UILabel+Extension.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/19/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public extension UILabel {
    func setFont(to typography: DesignSystem.Typography) {
        self.font = typography.description.font
    }

    func setTextColor(to color: DesignSystem.Color) {
        self.textColor = color.value
    }
}
