//
//  ContactUsButton.swift
//  Mobile
//
//  Created by Nika Chkadua on 9/24/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public class ContactUsButton: UIButton {
    private var phoneNumber = "+995322971010"

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup () {
        setSettings()
        setTitles()
        addTarget(self, action: #selector(call), for: .touchUpInside)
    }

    private func setSettings() {
        layer.cornerRadius = 25
        backgroundColor = R.color.colorGuide.systemBackground.tertiary()
        titleLabel?.textAlignment = .center
        imageEdgeInsets.right = 35
        titleEdgeInsets.left = 10

        setTitleColor(to: .primaryText(), for: .normal)
    }

    private func setTitles() {
        let title = R.string.localization.contact_us_button_title().makeAttributedString(with: .footnote(fontCase: .lower, fontStyle: .semiBold), lineSpasing: 0.12, foregroundColor: .primaryText())
        setAttributedTitle(title, for: .normal)
        setImage(R.image.shared.phone(), for: .normal)
    }

    @objc private func call() {
        guard let number = URL(string: "tel://" + phoneNumber) else { return }

        UIApplication.shared.open(number)
    }
}
