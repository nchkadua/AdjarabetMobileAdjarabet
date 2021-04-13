//
//  CashOutVisaView.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 4/6/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import UIKit

class CashOutVisaView: UIView, Xibable {
    @IBOutlet private weak var view: UIView!
    @IBOutlet private weak var amountInputView: ABInputView!
    @IBOutlet private weak var accountPickerView: ABInputView!
    @IBOutlet private weak var addAccountButton: UIButton!
    /* Summary */
    @IBOutlet private weak var summaryView: UIView!
    // Fee
    @IBOutlet private weak var feeTitleLabel: UILabel!
    @IBOutlet private weak var feeAmountView: UIView!
    @IBOutlet private weak var feeAmountLabel: UILabel!
    // Total
    @IBOutlet private weak var totalTitleLabel: UILabel!
    @IBOutlet private weak var totalAmountView: UIView!
    @IBOutlet private weak var totalAmountLabel: UILabel!
    /* Continue */
    @IBOutlet private weak var continueButton: ABButton!

    var mainView: UIView {
        get { view }
        set { view = newValue }
    }

    override init(frame: CGRect) {
       super.init(frame: frame)
       nibSetup()
    }

    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
       nibSetup()
    }

    func setupUI() {
        //
    }
}
