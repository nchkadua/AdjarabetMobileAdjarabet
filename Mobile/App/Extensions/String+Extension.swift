//
//  String+Extension.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/12/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public extension String {
    func makeAttributedString(with typography: DesignSystem.Typography,
                              alignment: NSTextAlignment = .left,
                              lineSpasing: CGFloat? = nil,
                              foregroundColor: DesignSystem.Color? = nil
    ) -> NSMutableAttributedString {
        let description = typography.description

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpasing ?? description.lineSpasing
        paragraphStyle.alignment = alignment
//        paragraphStyle.minimumLineHeight = description.lineHeight

        let attributedString = NSMutableAttributedString(string: self)
        var attrs: [NSAttributedString.Key: Any] = [
            .font: description.font,
            .paragraphStyle: paragraphStyle
        ]

        if let foregroundColor = foregroundColor {
            attrs[.foregroundColor] = foregroundColor.value
        }

        attributedString.addAttributes(attrs, range: NSRange(location: 0, length: attributedString.length))

        return attributedString
    }

    static let passwordRepresentation = "---------"

    var asPhoneNumber: String {
        var phoneNumber = self.dropLast(4)
        phoneNumber.append(contentsOf: "----")
        return String(phoneNumber)
    }

    var toDate: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dateFormatter.date(from: self) ?? Date()
    }
}
