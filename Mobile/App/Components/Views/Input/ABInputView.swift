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

    private var defaultBackgroundColor: DesignSystem.Color = DesignSystem.Input.backgroundColor
    private var hasDropdownImage = false

    // MARK: Formatter
    public var formatter: Formatter = DefaultFormatter()
    public var maxLength = -1

    /// PickerView
    public var pickerView = UIPickerView()
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
        formatText()
        configurePosition(animated: animate)
    }

    public func hideValidationText() {
        setValidation(text: nil)
    }

    public func setValidation(text: String?, color: DesignSystem.Color = .primaryRedNeutral()) {
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
            view.layoutIfNeeded()

            if hasDropdownImage {
                textField.isFirstResponder ? rotateUp() : rotateDown()
            }
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
        defaultBackgroundColor = color
        setupWrapperView(backgroundColor: color, borderWidth: width)
    }

    public func setLeftButtonImage(_ image: UIImage, for controlState: UIControl.State, tintColor: DesignSystem.Color = .primaryText()) {
        leftComponent.setImage(image, for: controlState)
        leftComponent.setTintColor(to: tintColor)
        leftComponent.superview?.isHidden = false
    }

    public func setRightButtonImage(_ image: UIImage, for controlState: UIControl.State, tintColor: DesignSystem.Color = .primaryText()) {
        rightComponent.setImage(image, for: controlState)
        rightComponent.setTintColor(to: tintColor)
        rightComponent.superview?.isHidden = false

        hasDropdownImage = false
    }

    public func setAccessibilityIdTextfield(id: String) {
        textField.accessibilityIdentifier = id
    }

    private func setDropdownImage(tintColor: DesignSystem.Color = .primaryText()) {
        rightComponent.setImage(R.image.shared.dropDown(), for: .normal)
        rightComponent.setTintColor(to: tintColor)
        rightComponent.superview?.isHidden = false

        hasDropdownImage = true
    }

    // MARK: Private Methods
    @objc private func makeTextFieldFirstResponderIfNeeded() {
        let canBecomeFirstResponder = textField.isUserInteractionEnabled && textField.canBecomeFirstResponder

        if canBecomeFirstResponder {
            textField.becomeFirstResponder()
        }
    }

    private func setupWrapperView(backgroundColor: DesignSystem.Color = DesignSystem.Input.backgroundColor, borderWidth: CGFloat = DesignSystem.Input.borderWidth) {
        defaultBackgroundColor = backgroundColor
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
        textField.delegate = self

        textFieldHeightConstraint.constant = size.textFieldHeight
        textFieldBottomConstraint.constant = textFieldBottomInset

        addToolBar()

        textField.rx.controlEvent([.editingDidBegin, .editingDidEnd]).subscribe(onNext: { [weak self] in
            self?.configurePosition(animated: true)
        })
        .disposed(by: disposeBag)
    }

    private func formatText() {
        let finalString = formatter.formatted(string: mainTextField.text ?? "")
        mainTextField.text = finalString
    }

    private func setupValidationResultLabel() {
        validationResultLabel.setFont(to: .caption1(fontCase: .lower))
        validationResultLabel.setTextColor(to: .primaryRedNeutral())
        validationResultLabel.superview?.isHidden = true
    }

    private func setupLeftButton() {
        leftButton.backgroundColor = nil
        leftButton.superview?.isHidden = true
    }

    private func setupRightButton() {
        rightButton.backgroundColor = nil
        rightButton.superview?.isHidden = true
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

    public func setDefaultValue(_ value: String) {
        guard !dataSourceItems.isEmpty else { return }

        setTextAndConfigure(text: value)
        pickerView.selectRow(dataSourceItems.firstIndex(of: value) ?? 0, inComponent: 0, animated: false)
    }

    private func setup() {
        mainTextField.inputView = pickerView
        mainTextField.tintColor = .clear
        pickerView.backgroundColor = DesignSystem.Color.secondaryBg().value
        pickerView.delegate = self
        pickerView.dataSource = self

        setDropdownImage()
    }

    private func addToolBar() {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = false
        toolBar.sizeToFit()

        toolBar.tintColor = DesignSystem.Color.primaryText().value
        toolBar.barTintColor = DesignSystem.Color.secondaryBg().value
        let doneButton = UIBarButtonItem(title: R.string.localization.cashflow_done_button_title(), style: UIBarButtonItem.Style.done, target: self, action: #selector(doneDidTap))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        toolBar.setItems([flexibleSpace, doneButton], animated: false)

        mainTextField.inputAccessoryView = toolBar
    }

    @objc private func doneDidTap() {
        mainTextField.resignFirstResponder()
    }

    func rotateUp() {
        rightButton.imageView?.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
    }

    func rotateDown() {
        rightButton.imageView?.transform = CGAffineTransform(rotationAngle: 0)
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

extension ABInputView: UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        guard defaultBackgroundColor != DesignSystem.Input.backgroundColor else { return }
        wrapperView.setBackgorundColor(to: .primaryFill())
    }

    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        guard defaultBackgroundColor != DesignSystem.Input.backgroundColor else { return true }
        wrapperView.setBackgorundColor(to: defaultBackgroundColor)

        return true
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        guard defaultBackgroundColor != DesignSystem.Input.backgroundColor else { return }
        formatText()
    }

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard maxLength > -1 else { return true }

        let currentString: NSString = (textField.text ?? "") as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
}
