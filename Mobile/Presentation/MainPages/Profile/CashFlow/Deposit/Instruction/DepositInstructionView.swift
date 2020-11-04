//
//  DepositInstructionView.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/30/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

class DepositInstructionView: UIView {
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

extension DepositInstructionView: Xibable {
    var mainView: UIView {
        get {
            view
        }
        set {
            view = newValue
        }
    }

    func setupUI() {
        view.backgroundColor = DesignSystem.Color.systemGray200().value
        view.layer.cornerRadius = 4

        titleLabel.setFont(to: .h3(fontCase: .lower))
        titleLabel.setTextColor(to: .systemWhite())
        titleLabel.text = R.string.localization.deposit_description_title()

        amountLabel.setFont(to: .body1)
        amountLabel.setTextColor(to: .systemWhite(alpha: 0.7))
        amountLabel.text = "\("•")   \(R.string.localization.deposit_description_amount())"

        cardLabel.setFont(to: .body1)
        cardLabel.setTextColor(to: .systemWhite(alpha: 0.7))
        cardLabel.text = "\("•")   \(R.string.localization.deposit_description_card())"

        proceedLabel.setFont(to: .body1)
        proceedLabel.setTextColor(to: .systemWhite(alpha: 0.7))
        proceedLabel.text = "\("•")   \(R.string.localization.deposit_description_proceed())"
    }
}
