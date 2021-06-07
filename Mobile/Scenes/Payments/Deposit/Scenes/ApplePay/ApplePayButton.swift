//
//  ApplePayButton.swift
//  Mobile
//
//  Created by Nika Chkadua on 4/7/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

class ApplePayButton: UIButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        setBackgorundColor(to: .primaryText())
        roundCorners(.allCorners, radius: 4)
        setTintColor(to: .primaryBg())

        setImage(R.image.deposit.apayIcon(), for: .normal)
    }
}
