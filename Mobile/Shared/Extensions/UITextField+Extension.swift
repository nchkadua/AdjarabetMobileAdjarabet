//
//  UITextField+Extension.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 5/11/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public extension UITextField {
    func setTextColor(to color: DesignSystem.Color?) {
        self.textColor = color?.value
    }

    func setFont(to typography: DesignSystem.Typography) {
        self.font = typography.description.font
    }
}
