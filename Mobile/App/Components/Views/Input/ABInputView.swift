//
//  ABInputView.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 5/11/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public class ABInputView: UIView {
    // MARK: Fields
    private let disposeBag = DisposeBag()

    // MARK: Outlets
    @IBOutlet private weak var view: UIView!

    @IBOutlet private weak var wrapperView: AppCircularView!
    @IBOutlet private weak var wrapperViewHeightConstraint: NSLayoutConstraint!

    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var textFieldHeightConstraint: NSLayoutConstraint!
    @IBOutlet private var textFieldCenterYConstraint: NSLayoutConstraint!
    @IBOutlet private var textFieldBottomConstraint: NSLayoutConstraint!

    @IBOutlet private weak var placeholderLabel: UILabel!
    @IBOutlet private var placeholderLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet private var placeholderLabelCenterYConstraint: NSLayoutConstraint!

    @IBOutlet private weak var leftButton: UIButton!
    @IBOutlet private weak var rightButton: UIButton!

    @IBOutlet private weak var validationResultLabel: UILabel!

    // MARK: Properties
    public var rx: Reactive<UITextField> { textField.rx }
    private var size: DesignSystem.Input.Size = .large
    private var textFieldBottomInset: CGFloat { size == .large ? 4 : 0 }
    private var placeholderLabelTopInset: CGFloat { size == .large ? 7 : 3 }

    public var mainTextField: UITextField { textField }
    public var leftComponent: UIButton { leftButton }
    public var rightComponent: UIButton { rightButton }

    /// PickerView
    private var pickerView = UIPickerView()
    private var dataSourceItems = [String]()

    // MARK: Init
    public override init(frame: CGRect) {
       super.init(frame: frame)
       nibSetup()
    }

    public required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
       nibSetup()
    }

    // MARK: Public Methods
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

    public func setValidation(text: String?, color: DesignSystem.Color = .systemRed300()) {
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
                to: textField.isFirstResponder ? DesignSystem.Input.borderColor : DesignSystem.Color.baseBg150(),
                animationDuration: animate ? 0.2 : 0)
            view.layoutIfNeeded()
        }

        if !animate {
            set()
            return
        }

        UIView.animate(withDuration: 0.2) {
            set()
        }
    }

    public func toggleSecureTextEntry() {
        textField.isSecureTextEntry.toggle()
    }

    public func becomeSecureTextEntry() {
        textField.isSecureTextEntry = true
    }

    public func dropSecureTextEntry() {
        textField.isSecureTextEntry = false
    }

    public func setupWith(backgroundColor color: DesignSystem.Color = DesignSystem.Input.backgroundColor, borderWidth width: CGFloat = DesignSystem.Input.borderWidth) {
        setupWrapperView(backgroundColor: color, borderWidth: width)
    }

    public func setLeftButtonImage(_ image: UIImage, for controlState: UIControl.State, tintColor: DesignSystem.Color = .primaryText()) {
        leftComponent.setImage(image, for: controlState)
        leftComponent.setTintColor(to: tintColor)
        leftComponent.superview?.isHidden = false
    }

    // MARK: Private Methods
    @objc private func makeTextFieldFirstResponderIfNeeded() {
        let canBecomeFirstResponder = textField.isUserInteractionEnabled && textField.canBecomeFirstResponder

        if canBecomeFirstResponder {
            textField.becomeFirstResponder()
        }
    }

    private func setupWrapperView(backgroundColor: DesignSystem.Color = DesignSystem.Input.backgroundColor, borderWidth: CGFloat = DesignSystem.Input.borderWidth) {
        wrapperView.setBackgorundColor(to: backgroundColor)
        wrapperView.borderWidth = borderWidth
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
        textField.autocorrectionType = .no
        textField.setFont(to: size.textFieldFont)
        textField.setTextColor(to: DesignSystem.Input.textFieldTextColor)
        textField.setTintColor(to: DesignSystem.Input.tintColor)
        textField.keyboardAppearance = .dark

        textFieldHeightConstraint.constant = size.textFieldHeight
        textFieldBottomConstraint.constant = textFieldBottomInset

        textField.rx.controlEvent([.editingDidBegin, .editingDidEnd]).subscribe(onNext: { [weak self] in
            self?.configurePosition(animated: true)
        })
        .disposed(by: disposeBag)
    }

    private func setupValidationResultLabel() {
        validationResultLabel.setFont(to: .body2)
        validationResultLabel.setTextColor(to: .systemRed300())
        validationResultLabel.superview?.isHidden = true
    }

    private func setupLeftButton() {
        leftButton.backgroundColor = nil
        leftButton.superview?.isHidden = true
    }

    private func setupRightButton() {
        rightButton.backgroundColor = nil
        rightButton.superview?.isHidden = false
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
}

// MARK: Picker
extension ABInputView {
    public func setupPickerView(withItems items: [String]) {
        dataSourceItems = items
        setup()
        addToolBar()
    }

    private func setup() {
        mainTextField.inputView = pickerView
        pickerView.backgroundColor = DesignSystem.Color.systemGray200().value
        pickerView.delegate = self
        pickerView.dataSource = self

        setTextAndConfigure(text: dataSourceItems.first)
    }

    private func addToolBar() {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = false
        toolBar.sizeToFit()

        toolBar.tintColor = DesignSystem.Color.systemWhite().value
        toolBar.barTintColor = DesignSystem.Color.systemGray200().value
        let doneButton = UIBarButtonItem(title: R.string.localization.cashflow_done_button_title(), style: UIBarButtonItem.Style.done, target: self, action: #selector(doneDidTap))
        toolBar.setItems([doneButton], animated: false)

        mainTextField.inputAccessoryView = toolBar
    }

    @objc private func doneDidTap() {
        mainTextField.resignFirstResponder()
    }
}

extension ABInputView: UIPickerViewDelegate {
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        setTextAndConfigure(text: dataSourceItems[row])
    }
}

extension ABInputView: UIPickerViewDataSource {
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        dataSourceItems.count
    }

    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        dataSourceItems[row]
    }
}
