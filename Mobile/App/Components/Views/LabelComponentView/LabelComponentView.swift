//
//  LabelComponentView.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/30/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

class LabelComponentView: UIView {
    // MARK: Outlets
    @IBOutlet weak private var view: UIView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var valueLabel: UILabel!

    public override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        nibSetup()
    }

    public func set(label: LabelComponentViewModel) {
        titleLabel.text = label.title
        valueLabel.text = label.value
    }

    public func change(value: String = "") {
        valueLabel.text = value
    }

    public func set(backgroundColor color: DesignSystem.Color) {
        view.backgroundColor = color.value
    }
}

extension LabelComponentView: Xibable {
    var mainView: UIView {
        get {
            view
        }
        set {
            view = newValue
        }
    }

    func setupUI() {
        view.backgroundColor = .clear

        titleLabel.setFont(to: .body1)
        titleLabel.setTextColor(to: .systemWhite())

        valueLabel.setFont(to: .h3(fontCase: .lower))
        valueLabel.setTextColor(to: .systemWhite())
    }
}

public struct LabelComponentViewModel {
    var title: String
    var value: String
}
