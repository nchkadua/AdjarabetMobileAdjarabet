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

    var toDateWithoutTime: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        if let date = dateFormatter.date(from: self) {
            print(date)
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter.date(from: dateFormatter.string(from: date)) ?? Date()
        }
        return Date()
    }

	// MARK: - Text Validations

	func isValidAddress() -> Bool { true }

	func isValidAmount() -> Bool { true }

	func isValidEmail() -> Bool {
		let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

		return NSPredicate(format: "SELF MATCHES %@", emailRegEx).evaluate(with: self)
	}

	func isValidEmailPrefix() -> Bool {
		count(char: "@") < 2
	}

	func isValidNumber() -> Bool {
		let numberStr = self.trimmingCharacters(in: .whitespacesAndNewlines)
		let regEx = "^\\d{\(count)}$"

		return NSPredicate(format: "SELF MATCHES[c] %@", regEx).evaluate(with: numberStr)
	}

	func isValidNumberPrefix() -> Bool {
		isEmpty || isValidNumber()
	}

	func isValidUsername() -> Bool {
		let regEx = "^[a-zA-Z0-9_]{4,20}$"

		return NSPredicate(format: "SELF MATCHES[c] %@", regEx).evaluate(with: self)
	}

	func isValidUsernamePrefix() -> Bool {
		let regEx = "^[a-zA-Z0-9_]{0,20}$"

		return NSPredicate(format: "SELF MATCHES[c] %@", regEx).evaluate(with: self)
	}

	// TODO: - validating phone number using exact policies
	func isValidPhoneNumberPrefix() -> Bool {
		let regEx = "^\\d{0,9}$"

		let phoneCheck = NSPredicate(format: "SELF MATCHES[c] %@", regEx)
		return phoneCheck.evaluate(with: self)
	}

	func isValidPhoneNumber() -> Bool {
		let regEx = "^\\d{9}$"

		return NSPredicate(format: "SELF MATCHES[c] %@", regEx).evaluate(with: self)
	}

	func isValidPassword() -> Bool { count >= 6 }

	func isValidPlainText() -> Bool { true }

	func count(char: Character) -> Int {
		map({ $0 == char ? 1 : 0 }).reduce(0, { $0 + $1 })
	}
}
