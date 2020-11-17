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

    public var rightImage: UIImage? {
        didSet {
            imageView.image = rightImage
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
        view.backgroundColor = DesignSystem.Color.primaryBg().value

        placeholderLabel.setFont(to: .subHeadline(fontCase: .lower))
        placeholderLabel.setTextColor(to: .secondaryText())

        titleLabel.setFont(to: .body(fontCase: .lower))
        titleLabel.setTextColor(to: .primaryText())
    }
}
