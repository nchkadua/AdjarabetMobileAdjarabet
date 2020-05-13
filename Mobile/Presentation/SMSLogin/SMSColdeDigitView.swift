//
//  SMSColdeDigitView.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 5/13/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

@IBDesignable
public class SMSCodeDigitView: AppCircularView {
    private var labelTopConstraint: NSLayoutConstraint?

    @IBInspectable
    public var text: String? {
        didSet {
            label.text = text
        }
    }

    @IBInspectable
    public var textColor: UIColor? {
        didSet {
            label.textColor = textColor
        }
    }

    public lazy var label: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textAlignment = .center
        l.setFont(to: .h1(fontCase: .upper))
        l.setTextColor(to: .neutral100())
        return l
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    fileprivate func initialize() {
        addSubview(label)
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        labelTopConstraint = label.topAnchor.constraint(equalTo: topAnchor, constant: 4)
        labelTopConstraint?.isActive = true

        let topConstraint = label.topAnchor.constraint(equalTo: bottomAnchor)
        topConstraint.priority = .init(999)
        topConstraint.isActive = true

        label.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        label.heightAnchor.constraint(equalTo: heightAnchor).isActive = true

        clipsToBounds = true

        cornerRadius = 4
        borderWidth = 1

        setText(nil)
    }

    public func setText(_ text: String?) {
        labelTopConstraint?.isActive = text != nil

        if text != nil {
            label.text = text
        }

        setBackgorundColor(to: text == nil ? .neutral700() : .neutral600())
        setBorderColor(to: text == nil ? .neutral500() : .neutral400())
        layoutIfNeeded()
    }
}
