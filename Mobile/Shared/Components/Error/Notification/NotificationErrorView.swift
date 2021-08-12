//
//  NotificationErrorView.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 8/11/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import UIKit

class NotificationErrorView: UIView, Xibable {
    @IBOutlet private weak var view: UIView!
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var messageLabel: UILabel!

    var mainView: UIView {
        get { view }
        set { view = newValue }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        nibSetup()
    }

    func setupUI() {
        contentView.setBackgorundColor(to: .ultrathin())
        messageLabel.setFont(to: .subHeadline(fontCase: .lower, fontStyle: .semiBold))
    }

    func configure(from model: ABError.Description.Notification) {
        iconImageView.image = model.icon
        messageLabel.text = model.description
    }
}
