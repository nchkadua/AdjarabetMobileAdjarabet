//
//  UITextView_Extension.swift
//  Mobile
//
//  Created by Nika Chkadua on 9/24/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public extension UITextView {
    func setTextColor(to color: DesignSystem.Color?) {
        self.textColor = color?.value
    }

    func setFont(to typography: DesignSystem.Typography) {
        self.font = typography.description.font
    }
}
