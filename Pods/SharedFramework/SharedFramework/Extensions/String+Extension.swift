extension String {
    public func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }

    public mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    public var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    
    public var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
	
	// MARK: - Text Validations
	
	public func isValidEmail() -> Bool {
		let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
		
		let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
		return emailPred.evaluate(with: self)
	}
	
	// TODO: - validating phone number using exact policies
	public func isValidPhoneNumberPrefix() -> Bool {
		let regEx = "^\\d{0,9}$"
		
		let phoneCheck = NSPredicate(format: "SELF MATCHES[c] %@", regEx)
		return phoneCheck.evaluate(with: self)
	}
	
	public func isValidPhoneNumber() -> Bool {
		let regEx = "^\\d{9}$"
		
		let phoneCheck = NSPredicate(format: "SELF MATCHES[c] %@", regEx)
		return phoneCheck.evaluate(with: self)
	}
	
	public func isValidPassword() -> Bool {
		// TODO - validate
		return true
	}
	
	private func isValidPlainText() -> Bool {
		return true
	}
}
