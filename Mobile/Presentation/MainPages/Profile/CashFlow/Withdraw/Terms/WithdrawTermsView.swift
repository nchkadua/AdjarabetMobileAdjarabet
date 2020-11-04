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

        bgView1.setBackgorundColor(to: .fill50())
        bgView1.layer.cornerRadius = 4
        bgView2.setBackgorundColor(to: .fill50())
        bgView2.layer.cornerRadius = 4

        infoImageView1.image = R.image.withdraw.info()
        infoImageView2.image = R.image.withdraw.info()

        ruleLabel1.setFont(to: .body1)
        ruleLabel1.setTextColor(to: .systemWhite())
        ruleLabel1.text = R.string.localization.withdraw_rule1()

        ruleLabel2.setFont(to: .body1)
        ruleLabel2.setTextColor(to: .systemWhite())
        ruleLabel2.text = R.string.localization.withdraw_rule2()
    }
}
