//
//  EmoneyButton.swift
//  Mobile
//
//  Created by Nika Chkadua on 3/24/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

class EmoneyButton: UIButton {
    private var animation = true

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        layer.cornerRadius = 4
        titleEdgeInsets.left = -40
        titleEdgeInsets.bottom = 3
        titleLabel?.alpha = 0.0

        setBackgorundColor(to: .primaryRed())
        setTintColor(to: .primaryText())
        setFont(to: .subHeadline(fontCase: .lower, fontStyle: .regular))

        setTitle(R.string.localization.emoney_goto.localized(), for: .normal)
        setImage(R.image.deposit.emoney_logo(), for: .normal)

        guard animation == true else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
            self.animate()
        })
    }

    public func animate() {
        titleEdgeInsets.left = 20
        UIView.animate(withDuration: 0.33, delay: 0.0, options: .curveEaseOut) {
            self.titleLabel?.alpha = 1.0
            self.layoutIfNeeded()
        }
    }
}
