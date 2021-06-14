//
//  PasswordChangeRulesView.swift
//  Mobile
//
//  Created by Nika Chkadua on 11/25/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

class PasswordChangeRulesView: UIView {
    // MARK: Outlets
    @IBOutlet weak private var view: UIView!
    @IBOutlet weak private var sv: UIStackView!
    @IBOutlet weak private var rule1ImageView: UIImageView!
    @IBOutlet weak private var rule1Label: UILabel!
    @IBOutlet weak private var rule2ImageView: UIImageView!
    @IBOutlet weak private var rule2Label: UILabel!
    @IBOutlet weak private var rule3ImageView: UIImageView!
    @IBOutlet weak private var rule3Label: UILabel!

    // MARK: Variables
    private static let animationTime = 0.15
    private static let specialRegex = ".*[!&^%$#@()/]+.*"
    private static let capitalLetterRegex = ".*[A-Z]+.*"
    private static let numbersRegex = ".*[0-9]+.*"
    private static let passwordMinimumCount = 6
    private static let passwordMaximumCount = 30

    public override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        nibSetup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        sv.layer.cornerRadius = 4
    }

    // MARK: Public methods
    public func updateRules(newPassword: String) {
        updateRule1(check: containsUppercase(password: newPassword))
        updateRule2(check: containsSpecialSymbol(password: newPassword))
        updateRule3(check: hasValidRange(password: newPassword))
    }

    // MARK: Private methods
    private func updateRule1(check: Bool) {
        if check {
            set(image: R.image.p2P.check() ?? UIImage(), imageView: rule1ImageView)
            set(textColor: .primaryText(), to: rule1Label)
        } else {
            set(image: R.image.components.accountInfo.oval() ?? UIImage(), imageView: rule1ImageView)
            set(textColor: .secondaryText(), to: rule1Label)
        }
    }

    private func updateRule2(check: Bool) {
        if check {
            set(image: R.image.p2P.check() ?? UIImage(), imageView: rule2ImageView)
            set(textColor: .primaryText(), to: rule2Label)
        } else {
            set(image: R.image.components.accountInfo.oval() ?? UIImage(), imageView: rule2ImageView)
            set(textColor: .secondaryText(), to: rule2Label)
        }
    }

    private func updateRule3(check: Bool) {
        if check {
            set(image: R.image.p2P.check() ?? UIImage(), imageView: rule3ImageView)
            set(textColor: .primaryText(), to: rule3Label)
        } else {
            set(image: R.image.components.accountInfo.oval() ?? UIImage(), imageView: rule3ImageView)
            set(textColor: .secondaryText(), to: rule3Label)
        }
    }

    // MARK: Animation methods
    private func set(image: UIImage, imageView: UIImageView) {
        UIView.transition(with: imageView, duration: PasswordChangeRulesView.animationTime, options: .transitionCrossDissolve, animations: {
            imageView.image = image
        }, completion: nil)
    }

    private func set(textColor: DesignSystem.Color, to label: UILabel) {
        UIView.transition(with: label, duration: PasswordChangeRulesView.animationTime, options: .transitionCrossDissolve, animations: {
            label.setTextColor(to: textColor)
        }, completion: nil)
    }

    // MARK: Validation methods
    private func containsUppercase(password: String) -> Bool {
        let capitalLetterRegEx = PasswordChangeRulesView.capitalLetterRegex
        let text = NSPredicate(format: "SELF MATCHES %@", capitalLetterRegEx)
        let capitalresult = text.evaluate(with: password)

        return capitalresult
    }

    private func containsSpecialSymbol(password: String) -> Bool {
        let specialCharacterRegEx = PasswordChangeRulesView.specialRegex
        let numbersCharacterRegEx = PasswordChangeRulesView.numbersRegex
        let text1 = NSPredicate(format: "SELF MATCHES %@", specialCharacterRegEx)
        let text2 = NSPredicate(format: "SELF MATCHES %@", numbersCharacterRegEx)
        let specialresult = text1.evaluate(with: password) || text2.evaluate(with: password)

        return specialresult
    }

    private func hasValidRange(password: String) -> Bool {
        password.count >= PasswordChangeRulesView.passwordMinimumCount && password.count <= PasswordChangeRulesView.passwordMaximumCount ? true : false
    }
}

extension PasswordChangeRulesView: Xibable {
    var mainView: UIView {
        get {
            view
        }
        set {
            view = newValue
        }
    }

    func setupUI() {
        view.backgroundColor = .clear

        sv.setBackgorundColor(to: .regular())

        rule1ImageView.image = R.image.components.accountInfo.oval()
        rule1ImageView.setTintColor(to: .secondaryText())
        rule1Label.setFont(to: .footnote(fontCase: .lower))
        rule1Label.setTextColor(to: .secondaryText())
        rule1Label.text = R.string.localization.rule1.localized()

        rule2ImageView.image = R.image.components.accountInfo.oval()
        rule2ImageView.setTintColor(to: .secondaryText())
        rule2Label.setFont(to: .footnote(fontCase: .lower))
        rule2Label.setTextColor(to: .secondaryText())
        rule2Label.text = R.string.localization.rule2.localized()

        rule3ImageView.image = R.image.components.accountInfo.oval()
        rule3ImageView.setTintColor(to: .secondaryText())
        rule3Label.setFont(to: .footnote(fontCase: .lower))
        rule3Label.setTextColor(to: .secondaryText())
        rule3Label.text = R.string.localization.rule3.localized()
    }
}
