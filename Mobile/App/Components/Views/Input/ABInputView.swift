//
//  ABInputView.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 5/11/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public class ABInputView: UIView {
    // MARK: Outlets
    @IBOutlet weak private var view: UIView!

    @IBOutlet private weak var wrapperView: AppCircularView!

    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private var textFieldCenterY: NSLayoutConstraint!
    @IBOutlet private var textFieldBottom: NSLayoutConstraint!

    @IBOutlet private weak var placeholderLabel: UILabel!
    @IBOutlet private var placeholderLabelCenterY: NSLayoutConstraint!

    @IBOutlet private weak var leftButton: UIButton!
    @IBOutlet private weak var rightButton: UIButton!

    @IBOutlet private weak var validationResultLabel: UILabel!

    private var placeholderPosition: PlaceholderPosition = .center

    public override init(frame: CGRect) {
       super.init(frame: frame)
       nibSetup()
    }

    public required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
       nibSetup()
    }

    @objc private func makeTextFieldFirstResponderIfNeeded() {
        let canBecomeFirstResponder = textField.isUserInteractionEnabled && textField.canBecomeFirstResponder

//        if !actionButton.isHidden && !canBecomeFirstResponder {
//            delegate?.actionButtonDidTap?(actionButton)
//            return
//        }

        if canBecomeFirstResponder {
            textField.becomeFirstResponder()
        }
    }

    private enum PlaceholderPosition {
        case top, center
    }

    private func setPlaceholderPosition(to position: PlaceholderPosition, animated animate: Bool) {
        self.placeholderPosition = position
        let isCenter = position == .center

        func set() {
            placeholderLabelCenterY.isActive = isCenter
            textFieldCenterY.isActive = isCenter
            textFieldBottom.isActive = !textFieldCenterY.isActive
            view.layoutIfNeeded()
        }

        if !animate {
            set()
            return
        }

        UIView.animate(withDuration: 0.25) {
            set()
        }
    }
}

extension ABInputView: Xibable {
    var mainView: UIView {
        get {
            view
        }
        set {
            view = newValue
        }
    }

    func setupUI() {
        setupWrapperView()
        setupTextField()
        setupValidationResultLabel()
        setupLeftButton()
        setupRightButton()
        setupPlaceholderLabel()

        setPlaceholderPosition(to: .center, animated: false)
    }

    private func setupWrapperView() {
        wrapperView.setBackgorundColor(to: DesignSystem.Input.backgroundColor)
        wrapperView.borderWidth = DesignSystem.Input.borderWidth
        wrapperView.cornerRadius = DesignSystem.Input.cornerRadius
        wrapperView.setBorderColor(to: DesignSystem.Input.borderColor)

        let tap = UITapGestureRecognizer(target: self, action: #selector(makeTextFieldFirstResponderIfNeeded))
        wrapperView.addGestureRecognizer(tap)
    }

    private func setupPlaceholderLabel() {
        placeholderLabel.setFont(to: DesignSystem.Input.placeholderFont)
        placeholderLabel.setTextColor(to: DesignSystem.Input.placeholTextColor)
    }

    private func setupTextField() {
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textField.autocorrectionType = .no
        textField.setFont(to: DesignSystem.Input.textFieldFont)
        textField.setTextColor(to: DesignSystem.Input.textFieldTextColor)
        textField.setTintColor(to: DesignSystem.Input.tintColor)
    }

    private func setupValidationResultLabel() {
        validationResultLabel.superview?.isHidden = true
    }

    private func setupLeftButton() {
        leftButton.superview?.isHidden = true
    }

    private func setupRightButton() {
        rightButton.superview?.isHidden = true
    }
}

extension ABInputView: UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        setPlaceholderPosition(to: .top, animated: true)
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        setPlaceholderPosition(to: .center, animated: true)
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        return delegate?.textFieldShouldReturn?(textField) ?? false
        textField.resignFirstResponder()
        return true
    }

    @objc fileprivate func textFieldDidChange(_ textField: UITextField) {
//        delegate?.textDidChange?(to: textField.text)
//
//        adjustPlaceholder()
    }
}
