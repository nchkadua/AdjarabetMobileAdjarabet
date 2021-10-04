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

	func isValidAddress() -> Bool {
		isValidInput()
	}

	func isValidAmount() -> Bool {
		isValidInput()
	}

	func isValidEmail() -> Bool {
		isMatch(regEx: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
	}

	func isValidEmailPrefix() -> Bool {
		isValidInput() && count(char: "@") < 2
	}

	func isValidInput() -> Bool {
		!contains(where: { c in !c.isASCII || c.asciiValue! < 32 || c.asciiValue! > 126 })
	}

	func isValidNumber() -> Bool {
		let numberStr = self.trimmingCharacters(in: .whitespacesAndNewlines)
		let regEx = "^\\d{\(count)}$"
		return numberStr.isMatch(regEx: regEx)
	}

	func isValidNumberPrefix() -> Bool {
		isEmpty || isValidNumber()
	}

	func isValidUsername() -> Bool {
//		isMatch(regEx: "^[a-zA-Z0-9_]{4,20}$")
		isValidInput()
	}

	func isValidUsernamePrefix() -> Bool {
//		isMatch(regEx: "^[a-zA-Z0-9_]{0,20}$")
		isValidInput()
	}

	func isValidPhoneNumberPrefix() -> Bool {
		isMatch(regEx: "^\\d{0,9}$")
	}

	func isValidPhoneNumber() -> Bool {
		isMatch(regEx: "^\\d{9}$")
	}

	func isValidPassword() -> Bool {
		isValidInput() && count >= 6
	}

	func isValidPlainText() -> Bool {
		isValidInput()
	}

	func count(char: Character) -> Int {
		map({ $0 == char ? 1 : 0 }).reduce(0, { $0 + $1 })
	}

	/// Checks if string matches appropriate regex
	func isMatch(regEx: String) -> Bool {
		NSPredicate(format: "SELF MATCHES[c] %@", regEx).evaluate(with: self)
	}

	// MARK: - [] - Subscripts

	var length: Int {
		return count
	}

	subscript (i: Int) -> String {
		return self[i ..< i + 1]
	}

	func substring(fromIndex: Int) -> String {
		return self[min(fromIndex, length) ..< length]
	}

	func substring(toIndex: Int) -> String {
		return self[0 ..< max(0, toIndex)]
	}

	subscript (r: Range<Int>) -> String {
		let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
											upper: min(length, max(0, r.upperBound))))
		let start = index(startIndex, offsetBy: range.lowerBound)
		let end = index(start, offsetBy: range.upperBound - range.lowerBound)
		return String(self[start ..< end])
	}

	func changeDateFormat(from fromFormat: String, to toFormat: String) -> String? {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = fromFormat
		if let date = dateFormatter.date(from: self) {
			dateFormatter.dateFormat = toFormat
			return dateFormatter.string(from: date)
		} else {
			return nil
		}
	}
}
