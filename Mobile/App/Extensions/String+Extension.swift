//
//  String+Extension.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/12/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public extension String {
    func makeAttributedString(with typographyDescription: DesignSystem.Typography.Description, alignment: NSTextAlignment = .left) -> NSMutableAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = typographyDescription.lineSpasing
        paragraphStyle.alignment = alignment
//        paragraphStyle.lineHeightMultiple = lineHeightMultiple

        let attributedString = NSMutableAttributedString(string: self)

        attributedString.addAttributes([
            .font: typographyDescription.font,
            .paragraphStyle: paragraphStyle
        ], range: NSRange(location: 0, length: attributedString.length))

        return attributedString
    }
}
