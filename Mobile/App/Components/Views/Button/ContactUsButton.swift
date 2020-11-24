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
    
    public override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        let titleRect = super.titleRect(forContentRect: contentRect)
        let imageSize = currentImage?.size ?? .zero
        let availableWidth = contentRect.width - imageEdgeInsets.right - imageSize.width - titleRect.width
        
        return titleRect.offsetBy(dx: round(availableWidth / 2), dy: 0)
    }

    private func setup () {
        setSettings()
        setTitles()
        addTarget(self, action: #selector(call), for: .touchUpInside)
    }

    private func setSettings() {
        layer.cornerRadius = 25
        setBackgorundColor(to: .querternaryBg())
        titleLabel?.textAlignment = .left
        setTintColor(to: .primaryText())

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

    // MARK: Public Methods
    public func setCornerRadius(_ radius: CGFloat = 25) {
        layer.cornerRadius = radius
    }
}
