//
//  VisaLimitComponentView.swift
//  Mobile
//
//  Created by Nika Chkadua on 3/25/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

class VisaLimitComponentView: UIView {
    @IBOutlet weak private var view: UIView!
    @IBOutlet weak private var minLimitTitleLabel: UILabel!
    @IBOutlet weak private var minLimitLabel: UILabel!
    @IBOutlet weak private var dailyLimitTitleLabel: UILabel!
    @IBOutlet weak private var dailyLimitLabel: UILabel!
    @IBOutlet weak private var maxLimitTitleLabel: UILabel!
    @IBOutlet weak private var maxLimitLabel: UILabel!

    @IBOutlet weak private var sv1: UIStackView!
    @IBOutlet weak private var sv2: UIStackView!
    @IBOutlet weak private var sv3: UIStackView!

    public override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        nibSetup()
    }

    public func updateMin(_ minLimit: String) {
        minLimitLabel.setTextWithAnimation(minLimit)
    }

    public func updateDaily(_ dailyLimit: String) {
        dailyLimitLabel.setTextWithAnimation(dailyLimit)
    }

    public func updateMax(_ maxLimit: String) {
        maxLimitLabel.setTextWithAnimation(maxLimit)
    }
}

extension VisaLimitComponentView: Xibable {
    var mainView: UIView {
        get {
            view
        }
        set {
            view = newValue
        }
    }

    func setupUI() {
        backgroundColor = .clear
        roundCorners(radius: 4)

        minLimitTitleLabel.setTextColor(to: .secondaryText())
        minLimitTitleLabel.setFont(to: .caption2(fontCase: .lower, fontStyle: .regular))
        minLimitTitleLabel.text = R.string.localization.visa_min_limit.localized()

        minLimitLabel.setTextColor(to: .primaryText())
        minLimitLabel.setFont(to: .callout(fontCase: .lower, fontStyle: .semiBold))

        dailyLimitTitleLabel.setTextColor(to: .secondaryText())
        dailyLimitTitleLabel.setFont(to: .caption2(fontCase: .lower, fontStyle: .regular))
        dailyLimitTitleLabel.text = R.string.localization.visa_daily_limit.localized()

        dailyLimitLabel.setTextColor(to: .primaryText())
        dailyLimitLabel.setFont(to: .callout(fontCase: .lower, fontStyle: .semiBold))

        maxLimitTitleLabel.setTextColor(to: .secondaryText())
        maxLimitTitleLabel.setFont(to: .caption2(fontCase: .lower, fontStyle: .regular))
        maxLimitTitleLabel.text = R.string.localization.visa_max_limit.localized()

        maxLimitLabel.setTextColor(to: .primaryText())
        maxLimitLabel.setFont(to: .callout(fontCase: .lower, fontStyle: .semiBold))

        sv1.setBackgorundColor(to: .thin())
        sv2.setBackgorundColor(to: .thin())
        sv3.setBackgorundColor(to: .thin())
    }
}
