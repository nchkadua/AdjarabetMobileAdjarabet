//
//  String+Extension.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/12/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public extension String {
    func makeAttributedString(with typography: DesignSystem.Typography, alignment: NSTextAlignment = .left) -> NSMutableAttributedString {
        let description = typography.description

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = description.lineSpasing
        paragraphStyle.alignment = alignment
//        paragraphStyle.lineHeightMultiple = description.lineHeight

        let attributedString = NSMutableAttributedString(string: self)

        attributedString.addAttributes([
            .font: description.font,
            .paragraphStyle: paragraphStyle
        ], range: NSRange(location: 0, length: attributedString.length))

        return attributedString
    }
}
