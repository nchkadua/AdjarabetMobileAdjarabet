//
//  WithdrawInstructionView.swift
//  Mobile
//
//  Created by Nika Chkadua on 11/1/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

class WithdrawInstructionView: UIView {
    // MARK: Outlets
    @IBOutlet weak private var view: UIView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var amountLabel: UILabel!
    @IBOutlet weak private var cardLabel: UILabel!
    @IBOutlet weak private var proceedLabel: UILabel!

    public override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        nibSetup()
    }
}

extension WithdrawInstructionView: Xibable {
    var mainView: UIView {
        get {
            view
        }
        set {
            view = newValue
        }
    }

    func setupUI() {
        view.setBackgorundColor(to: .tertiaryBg())
        view.layer.cornerRadius = 8

        titleLabel.setFont(to: .subHeadline(fontCase: .lower, fontStyle: .semiBold))
        titleLabel.setTextColor(to: .primaryText())
        titleLabel.text = R.string.localization.withdraw_description_title()

        amountLabel.setFont(to: .footnote(fontCase: .lower))
        amountLabel.setTextColor(to: .primaryText())
        amountLabel.text = "\("•")   \(R.string.localization.withdraw_description_amount())"

        cardLabel.setFont(to: .footnote(fontCase: .lower))
        cardLabel.setTextColor(to: .primaryText())
        cardLabel.text = "\("•")   \(R.string.localization.withdraw_description_card())"

        proceedLabel.setFont(to: .footnote(fontCase: .lower))
        proceedLabel.setTextColor(to: .primaryText())
        proceedLabel.text = "\("•")   \(R.string.localization.withdraw_description_proceed())"
    }
}
