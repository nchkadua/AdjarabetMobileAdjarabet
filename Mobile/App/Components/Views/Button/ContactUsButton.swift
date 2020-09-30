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
        layer.cornerRadius = 5
        backgroundColor = R.color.colorGuide.global.baseBg100()
        titleLabel?.textAlignment = .left
        imageEdgeInsets.left = 15
        titleEdgeInsets.left = 30

        setTitleColor(to: .systemWhite(alpha: 0.7), for: .normal)
    }

    private func setTitles() {
        let title1 = R.string.localization.contact_us_button_title1().makeAttributedString(with: .h6(fontCase: .lower), lineSpasing: 0.12, foregroundColor: .systemWhite(alpha: 0.7))
        let title2 = "   \(R.string.localization.contact_us_button_title2())".makeAttributedString(with: .h4(fontCase: .lower), lineSpasing: 0.12, foregroundColor: .systemWhite())

        title1.append(title2)

        setAttributedTitle(title1, for: .normal)
        setImage(R.image.shared.phone(), for: .normal)
    }

    @objc private func call() {
        guard let number = URL(string: "tel://" + phoneNumber) else { return }

        UIApplication.shared.open(number)
    }
}
