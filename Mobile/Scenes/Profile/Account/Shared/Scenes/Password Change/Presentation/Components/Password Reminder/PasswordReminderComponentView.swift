//
//  PasswordReminderComponentView.swift
//  Mobile
//
//  Created by Nika Chkadua on 5/20/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//
class PasswordReminderComponentView: UIView {
    // MARK: Outlets
    @IBOutlet weak private var view: UIView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var mainButton: UIButton!

    public var button: UIButton { mainButton }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        nibSetup()
    }
}

extension PasswordReminderComponentView: Xibable {
    var mainView: UIView {
        get {
            view
        }
        set {
            view = newValue
        }
    }

    func setupUI() {
        view.backgroundColor = DesignSystem.Color.secondaryBg().value

        titleLabel.setFont(to: .subHeadline(fontCase: .lower, fontStyle: .regular))
        titleLabel.setTextColor(to: .secondaryText())
        titleLabel.text = R.string.localization.forgot_password.localized()

        mainButton.setBackgorundColor(to: .secondaryFill())
        mainButton.setFont(to: .subHeadline(fontCase: .lower, fontStyle: .semiBold))
        mainButton.setTitle(R.string.localization.remind_button_title().lowercased(), for: .normal)
        mainButton.setTintColor(to: .primaryText())
        mainButton.roundCorners(radius: 5)
    }
}
