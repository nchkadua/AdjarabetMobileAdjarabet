//
//  AccountInfoComponentView.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/22/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public class AccountInfoComponentView: UIView {
    // MARK: Outlets
    @IBOutlet weak private var view: UIView!
    @IBOutlet weak private var placeholderLabel: UILabel!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var separator: UIView!

    @IBOutlet weak private var titleLabelTrailingConstraint: NSLayoutConstraint!

    public var isClickable: Bool = false {
        didSet {
            imageView.isHidden = !isClickable
            titleLabelTrailingConstraint.constant = 8
        }
    }

    public var hidesSeparator: Bool = false {
        didSet {
            separator.isHidden = hidesSeparator
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        nibSetup()
    }

    public func set(placeholderText: String = "", titleText: String = "") {
        if !placeholderText.isEmpty {
            placeholderLabel.text = placeholderText
        }
        if !titleText.isEmpty {
            titleLabel.text = titleText
        }
    }

    public func set(titleTextColor: DesignSystem.Color) {
        titleLabel.setTextColor(to: titleTextColor)
    }
}

extension AccountInfoComponentView: Xibable {
    var mainView: UIView {
        get {
            view
        }
        set {
            view = newValue
        }
    }

    func setupUI() {
        view.setBackgorundColor(to: .tertiaryBg())

        placeholderLabel.setFont(to: .callout(fontCase: .lower, fontStyle: .semiBold))
        placeholderLabel.setTextColor(to: .primaryText())

        titleLabel.setFont(to: .callout(fontCase: .lower, fontStyle: .semiBold))
        titleLabel.setTextColor(to: .secondaryText())

        imageView.isHidden = true
        titleLabelTrailingConstraint.constant = -10

        separator.setBackgorundColor(to: .nonOpaque())
    }
}
