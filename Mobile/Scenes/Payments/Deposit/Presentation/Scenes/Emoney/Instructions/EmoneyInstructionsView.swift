//
//  EmoneyInstructionsView.swift
//  Mobile
//
//  Created by Nika Chkadua on 3/24/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

class EmoneyInstructionsView: UIView {
    // MARK: Outlets
    @IBOutlet weak private var view: UIView!
    @IBOutlet weak private var iconImageView: UIImageView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var label1: UILabel!
    @IBOutlet weak private var rule1Label: UILabel!
    @IBOutlet weak private var label2: UILabel!
    @IBOutlet weak private var rule2Label: UILabel!
    @IBOutlet weak private var label3: UILabel!
    @IBOutlet weak private var rule3Label: UILabel!

    public override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        nibSetup()
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        style(label1)
        style(label2)
        style(label3)
    }
}

extension EmoneyInstructionsView: Xibable {
    var mainView: UIView {
        get {
            view
        }
        set {
            view = newValue
        }
    }

    func setupUI() {
        view.setBackgorundColor(to: .thin())
        roundCorners(.allCorners, radius: 4)

        iconImageView.image = R.image.deposit.rules_icon()
        titleLabel.setTextColor(to: .primaryText())
        titleLabel.setFont(to: .body1(fontCase: .lower, fontStyle: .semiBold))
        titleLabel.text = R.string.localization.emoney_instruction_title.localized()

        rule1Label.setTextColor(to: .secondaryText())
        rule1Label.setFont(to: .footnote(fontCase: .lower, fontStyle: .regular))
        rule1Label.text = R.string.localization.emoney_rule1.localized()
        rule1Label.numberOfLines = 3

        rule2Label.setTextColor(to: .secondaryText())
        rule2Label.setFont(to: .footnote(fontCase: .lower, fontStyle: .regular))
        rule2Label.text = R.string.localization.emoney_rule2.localized()
        rule2Label.numberOfLines = 3

        rule3Label.setTextColor(to: .secondaryText())
        rule3Label.setFont(to: .footnote(fontCase: .lower, fontStyle: .regular))
        rule3Label.text = R.string.localization.emoney_rule3.localized()
        rule3Label.numberOfLines = 3
    }

    private func style(_ label: UILabel) {
        label.setBackgorundColor(to: .systemGrey5())
        label.setTextColor(to: .primaryText())
        label.setFont(to: .callout(fontCase: .lower, fontStyle: .semiBold))
        label.roundCorners(.allCorners, radius: label.frame.width / 2)
    }
}
