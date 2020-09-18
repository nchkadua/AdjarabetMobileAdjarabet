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
        l.setTextColor(to: .separator())
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

    public func setText(_ text: String?, animationDuration duration: TimeInterval? = nil) {
        let hasText = text != nil && !text!.isEmpty

        func set() {
            labelTopConstraint?.isActive = hasText

            if hasText {
                label.text = text
            }

            setBackgorundColor(to: text == nil ? .baseBg100() : .fill140())
            setBorderColor(to: text == nil ? .fill110() : .fill50(), animationDuration: duration ?? 0)
            layoutIfNeeded()
        }

        UIView.animate(withDuration: duration ?? 0) { set() }
    }
}
