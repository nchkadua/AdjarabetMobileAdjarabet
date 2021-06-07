//
//  SMSCodeInputView.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 5/13/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public class SMSCodeInputView: AppCircularView {
    private var smsCodeDigitViews: [SMSCodeDigitView] {
        stackView.arrangedSubviews.compactMap { $0 as? SMSCodeDigitView }
    }

    public lazy var stackView: UIStackView = {
        let s = UIStackView()
        s.translatesAutoresizingMaskIntoConstraints = false
        s.distribution = .fillEqually
        s.axis = .horizontal
        s.alignment = .fill
        s.spacing = 0
        s.setBackgorundColor(to: .thick())
        return s
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        stackView.roundCorners(.allCorners, radius: 6)
    }

    private func initialize() {
        addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: -5).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }

    public func configureForNumberOfItems(_ count: Int) {
        stackView.removeAllSubViews()
        (0..<count).forEach { _ in
            let v = SMSCodeDigitView()
            v.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(v)
        }
    }

    public subscript(index: Int) -> SMSCodeDigitView {
        smsCodeDigitViews[index]
    }
}
