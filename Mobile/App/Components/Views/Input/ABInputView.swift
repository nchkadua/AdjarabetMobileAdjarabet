//
//  ABInputView.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 5/11/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public class ABInputView: UIView {
    // MARK: Outlets
    @IBOutlet private weak var view: UIView!

    @IBOutlet private weak var wrapperView: AppCircularView!
    @IBOutlet private weak var wrapperViewHeightConstraint: NSLayoutConstraint!

    @IBOutlet public weak var textField: UITextField!
    @IBOutlet private weak var textFieldHeightConstraint: NSLayoutConstraint!
    @IBOutlet private var textFieldCenterYConstraint: NSLayoutConstraint!
    @IBOutlet private var textFieldBottomConstraint: NSLayoutConstraint!

    @IBOutlet public weak var placeholderLabel: UILabel!
    @IBOutlet private var placeholderLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet private var placeholderLabelCenterYConstraint: NSLayoutConstraint!

    @IBOutlet public weak var leftButton: UIButton!
    @IBOutlet public weak var rightButton: UIButton!

    @IBOutlet public weak var validationResultLabel: UILabel!

    // MARK: Fields
    private var size: DesignSystem.Input.Size = .large
    private var textFieldBottomInset: CGFloat { size == .large ? 4 : 0 }
    private var placeholderLabelTopInset: CGFloat { size == .large ? 7 : 3 }

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

        if canBecomeFirstResponder {
            textField.becomeFirstResponder()
        }
    }

    public func set(text: String?) {
        setTextAndConfigure(text: text)
    }

    public func setPlaceholder(text: String?) {
        placeholderLabel.text = text
    }

    public func setTextAndConfigure(text: String?, animated animate: Bool = false) {
        textField.text = text
        configurePosition(animated: animate)
    }

    public func hideValidationText() {
        setValidation(text: nil)
    }

    public func setValidation(text: String?, color: DesignSystem.Color = .error()) {
        validationResultLabel.text = text
        validationResultLabel.setTextColor(to: color)
        validationResultLabel.superview?.isHidden = text == nil
    }

    public func setSize(to size: DesignSystem.Input.Size) {
        self.size = size

        wrapperViewHeightConstraint.constant = size.height

        textField.setFont(to: size.textFieldFont)
        textFieldHeightConstraint.constant = size.textFieldHeight
        textFieldBottomConstraint.constant = textFieldBottomInset

        placeholderLabelTopConstraint.constant = placeholderLabelTopInset
    }

    public func configurePosition(animated animate: Bool) {
        let isCenter = !(textField.isFirstResponder || textField.text?.isEmpty == false)

        func set() {
            placeholderLabelCenterYConstraint.isActive  = isCenter
            textFieldCenterYConstraint.isActive         = isCenter
            textFieldBottomConstraint.isActive          = !textFieldCenterYConstraint.isActive
            wrapperView.setBorderColor(
                to: textField.isFirstResponder ? DesignSystem.Input.borderColor : DesignSystem.Input.backgroundColor,
                animationDuration: animate ? 0.25 : 0)
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

        configurePosition(animated: false)
    }

    private func setupWrapperView() {
        wrapperView.setBackgorundColor(to: DesignSystem.Input.backgroundColor)
        wrapperView.borderWidth = DesignSystem.Input.borderWidth
        wrapperView.cornerRadius = DesignSystem.Input.cornerRadius
        wrapperView.setBorderColor(to: DesignSystem.Input.borderColor)

        let tap = UITapGestureRecognizer(target: self, action: #selector(makeTextFieldFirstResponderIfNeeded))
        wrapperView.addGestureRecognizer(tap)

        wrapperViewHeightConstraint.constant = size.height
    }

    private func setupPlaceholderLabel() {
        placeholderLabel.setTextColor(to: DesignSystem.Input.placeholTextColor)
        placeholderLabel.setFont(to: DesignSystem.Input.placeholderFont)
        placeholderLabelTopConstraint.constant = placeholderLabelTopInset

        hideValidationText()
    }

    private func setupTextField() {
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textField.autocorrectionType = .no
        textField.setFont(to: size.textFieldFont)
        textField.setTextColor(to: DesignSystem.Input.textFieldTextColor)
        textField.setTintColor(to: DesignSystem.Input.tintColor)
        textField.keyboardAppearance = .dark

        textFieldHeightConstraint.constant = size.textFieldHeight
        textFieldBottomConstraint.constant = textFieldBottomInset
    }

    private func setupValidationResultLabel() {
        validationResultLabel.setFont(to: .body2)
        validationResultLabel.setTextColor(to: .error())
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
        configurePosition(animated: true)
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        configurePosition(animated: true)
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        return delegate?.textFieldShouldReturn?(textField) ?? false
        textField.resignFirstResponder()
        return true
    }

    @objc fileprivate func textFieldDidChange(_ textField: UITextField) {

    }
}
