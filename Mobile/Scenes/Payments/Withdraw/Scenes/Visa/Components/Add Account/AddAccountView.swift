//
//  AddAccountView.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 4/5/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import UIKit

class AddAccountView: UIView, Xibable {
    @IBOutlet private weak var view: UIView!
    @IBOutlet private weak var addCardView: UIView!
    @IBOutlet private weak var addCardButton: UIButton!
    @IBOutlet private weak var addCardTitleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!

    var mainView: UIView {
        get { view }
        set { view = newValue }
    }

    var button: UIButton { addCardButton }

    override init(frame: CGRect) {
       super.init(frame: frame)
       nibSetup()
    }

    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
       nibSetup()
    }

    func setupUI() {
        view.backgroundColor = .clear
        addCardView.setBackgorundColor(to: .tertiaryBg())

        addCardTitleLabel.setTextColor(to: .primaryText())
        addCardTitleLabel.setFont(to: .callout(fontCase: .lower, fontStyle: .semiBold))
        addCardTitleLabel.setTextWithAnimation(R.string.localization.withdraw_add_card.localized())

        descriptionLabel.setTextColor(to: .secondaryText())
        descriptionLabel.setFont(to: .footnote(fontCase: .lower, fontStyle: .regular))
        descriptionLabel.setTextWithAnimation(R.string.localization.withdraw_add_card_description.localized())
    }
}
