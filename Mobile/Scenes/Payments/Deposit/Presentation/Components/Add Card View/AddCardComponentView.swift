//
//  AddCardComponentView.swift
//  Mobile
//
//  Created by Nika Chkadua on 4/7/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

class AddCardComponentView: UIView {
    @IBOutlet weak private var view: UIView!
    @IBOutlet weak private var bgView: UIView!
    @IBOutlet weak private var addCardButton: UIButton!
    @IBOutlet weak private var buttonTitleLabel: UILabel!
    @IBOutlet weak private var viewTitleLabel: UILabel!

    public var button: UIButton { addCardButton }
    public var titleLabel: UILabel { viewTitleLabel }

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
        bgView.roundCorners(radius: 8)
    }
}

extension AddCardComponentView: Xibable {
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
        bgView.setBackgorundColor(to: .tertiaryBg())

        buttonTitleLabel.setTextColor(to: .primaryText())
        buttonTitleLabel.setFont(to: .callout(fontCase: .lower, fontStyle: .semiBold))
        buttonTitleLabel.setTextWithAnimation(R.string.localization.deposit_visa_add_card_button_title.localized())

        viewTitleLabel.setTextColor(to: .secondaryText())
        viewTitleLabel.setFont(to: .footnote(fontCase: .lower, fontStyle: .regular))
        viewTitleLabel.setTextWithAnimation(R.string.localization.deposit_visa_add_card_title.localized())
        viewTitleLabel.numberOfLines = 2
    }
}
