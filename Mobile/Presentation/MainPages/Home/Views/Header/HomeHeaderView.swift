//
//  HomeHeaderView.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 4/26/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

class HomeHeaderView: UIView, Xibable {
    @IBOutlet private weak var view: UIView!
    @IBOutlet private weak var balance: BalanceProfileButton!

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
        setupBalance()
    }

    private func setupBalance() {
        balance.setFont(to: .footnote(fontCase: .upper, fontStyle: .semiBold))
        balance.setTitleColor(to: .primaryText(), for: .normal)
        balance.setTintColor(to: .primaryText())
        balance.setImage(R.image.shared.navBar.profile()?.resizeImage(newHeight: 20), for: .normal)
        balance.semanticContentAttribute = .forceRightToLeft
        balance.titleEdgeInsets = UIEdgeInsets(top: 4, left: -8, bottom: 0, right: 0)
        balance.contentEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
    }
}
