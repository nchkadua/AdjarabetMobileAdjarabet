//
//  WithdrawVisaInfoView.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 4/6/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

class WithdrawVisaInfoView: UIView, Xibable {
    @IBOutlet private weak var view: UIView!
    @IBOutlet private weak var contentView: UIView!

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
