//
//  WithdrawTermsView.swift
//  Mobile
//
//  Created by Nika Chkadua on 11/1/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

class WithdrawTermsView: UIView {
    // MARK: Outlets
    @IBOutlet weak private var view: UIView!
    @IBOutlet weak private var bgView1: UIView!
    @IBOutlet weak private var infoImageView1: UIImageView!
    @IBOutlet weak private var ruleLabel1: UILabel!
    @IBOutlet weak private var bgView2: UIView!
    @IBOutlet weak private var infoImageView2: UIImageView!
    @IBOutlet weak private var ruleLabel2: UILabel!

    public override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        nibSetup()
    }
}

extension WithdrawTermsView: Xibable {
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

        bgView1.setBackgorundColor(to: .tertiaryBg())
        bgView1.layer.cornerRadius = 8
        bgView2.setBackgorundColor(to: .tertiaryBg())
        bgView2.layer.cornerRadius = 8

        infoImageView1.image = R.image.withdraw.info()
        infoImageView2.image = R.image.withdraw.info()

        ruleLabel1.setFont(to: .footnote(fontCase: .lower))
        ruleLabel1.setTextColor(to: .primaryText())
        ruleLabel1.text = R.string.localization.withdraw_rule1()

        ruleLabel2.setFont(to: .footnote(fontCase: .lower))
        ruleLabel2.setTextColor(to: .primaryText())
        ruleLabel2.text = R.string.localization.withdraw_rule2()
    }
}
