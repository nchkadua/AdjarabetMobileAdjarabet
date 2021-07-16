//
//  PasswordResetViewController.swift
//  Mobile
//
//  Created by Nika Chkadua on 30.06.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public class PasswordResetViewController: ABViewController {
    @Inject(from: .viewModels) public var viewModel: PasswordResetViewModel
    public lazy var navigator = NewPasswordNavigator(viewController: self)

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel1: UILabel!
    @IBOutlet private weak var subtitleLabel2: UILabel!
    @IBOutlet private weak var contactInputView: ABInputView!
    @IBOutlet private weak var newPasswordInputView: ABInputView!
    @IBOutlet private weak var repeatePasswordInputView: ABInputView!
    @IBOutlet private weak var updatePasswordButton: ABButton!
    @IBOutlet private weak var passwordChangeRulesView: PasswordChangeRulesView!

    private var passwordReminderComponentView: PasswordReminderComponentView?

    // MARK: - Lifecycle methods
    public override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        contactInputView.mainTextField.becomeFirstResponder()
    }

    // MARK: Bind to viewModel's observable properties
    private func bind(to viewModel: PasswordResetViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)

        viewModel.route.subscribe(onNext: { [weak self] route in
            self?.didRecive(route: route)
        }).disposed(by: disposeBag)
    }

    private func didRecive(action: PasswordResetViewModelOutputAction) {
        switch action {
        case .setButton(let loading): updatePasswordButton.set(isLoading: loading)
        case .updateRulesWithNewPassword(let newPassword): passwordChangeRulesView.updateRules(newPassword: newPassword)
        case .showMessage(let message): showAlert(title: message) { _ in // Need to be changed after error handling system integrated
                self.dismiss(animated: true, completion: nil)
            }
        case .setupPhoneNumber(let number):
            contactInputView.set(text: number)
        case .setupWith(let resetType, let contact): setupTitles(resetType: resetType, contact: contact)
        }
    }

    private func didRecive(route: PasswordResetViewModelRoute) {
        switch route {
        case .openOTP(let params): navigator.navigate(to: .OTP(params: params), animated: true)
        }
    }

    //
    private func setupTitles(resetType: PasswordResetType, contact: String) {
        switch resetType {
        case .sms: setupAsSms(contact)
        case .email: setupAsEmail(contact)
        }
    }

    private func setupAsSms(_ contact: String) {
        let phone = ""
        contactInputView.setTextAndConfigure(text: phone.appending(contact.dropLast(4)))
        subtitleLabel1.text = R.string.localization.reset_password_hint_phone.localized()
        contactInputView.mainTextField.keyboardType = .numberPad
    }

    private func setupAsEmail(_ contact: String) {
        subtitleLabel1.text = "\(R.string.localization.reset_password_hint_mail.localized()) \("(")\(contact)\(")")"
        contactInputView.mainTextField.keyboardType = .emailAddress
    }

    // MARK: Setup methods
    private func setup() {
        setBaseBackgorundColor(to: .secondaryBg())
        setupNavigationItems()
        setupKeyboard()
        setupLabel()
        setupInputViews()
        setupInputViewsObservation()
        setupPasswordButton()
    }

    private func setupNavigationItems() {
        let backButtonGroup = makeBackBarButtonItem(width: 60, title: R.string.localization.back_button_title.localized())
        navigationItem.leftBarButtonItem = backButtonGroup.barButtonItem
        backButtonGroup.button.addTarget(self, action: #selector(backButtonClick), for: .touchUpInside)

        guard viewModel.params.showDismissButton else {return}

        let dismissButtonGroup = makeBarrButtonWith(title: R.string.localization.reset_password_dismiss_button_title.localized())
        navigationItem.rightBarButtonItem = dismissButtonGroup.barButtonItem
        dismissButtonGroup.button.addTarget(self, action: #selector(dismissButtonClick), for: .touchUpInside)
    }

    @objc private func backButtonClick() {
        if viewModel.params.showDismissButton {
            navigationController?.popToRootViewController(animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }

    @objc private func dismissButtonClick() {
        dismiss(animated: true, completion: nil)
    }

    private func setupLabel() {
        titleLabel.setFont(to: .title2(fontCase: .lower, fontStyle: .semiBold))
        titleLabel.setTextColor(to: .primaryText())
        titleLabel.text = R.string.localization.password_reset_title.localized()

        subtitleLabel1.setFont(to: .footnote(fontCase: .lower, fontStyle: .semiBold))
        subtitleLabel1.setTextColor(to: .secondaryText())

        subtitleLabel2.setFont(to: .footnote(fontCase: .lower, fontStyle: .semiBold))
        subtitleLabel2.setTextColor(to: .secondaryText())
        subtitleLabel2.text = R.string.localization.reset_password_hint2.localized()
    }

    private func setupInputViews() {
        contactInputView.setupWith(backgroundColor: .querternaryFill(), borderWidth: 0, hidesPlaceholder: true)
        contactInputView.mainTextField.setFont(to: .title3(fontCase: .lower, fontStyle: .regular))
        contactInputView.mainTextField.textAlignment = .center
        contactInputView.mainTextField.delegate = self

        styleInputView(newPasswordInputView, with: R.string.localization.new_password.localized())
        newPasswordInputView.mainTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

        styleInputView(repeatePasswordInputView, with: R.string.localization.repeat_password.localized())
    }

    private func styleInputView(_ inputView: ABInputView, with placeholder: String) {
        inputView.setupWith(backgroundColor: .querternaryFill(), borderWidth: 0)
        inputView.mainTextField.textContentType = .password
        inputView.setPlaceholder(text: placeholder)
        inputView.setSize(to: .large)
        inputView.becomeSecureTextEntry()
        inputView.setRightButtonImage(R.image.shared.hideText() ?? UIImage(), for: .normal)

        inputView.rightComponent.rx.tap.subscribe(onNext: { [weak self] in
            self?.updateRightButton(of: inputView)
        }).disposed(by: disposeBag)

        var inputArray = [repeatePasswordInputView.rx.text.orEmpty, newPasswordInputView.rx.text.orEmpty]
        if viewModel.params.resetType == .email {
            inputArray.append(contactInputView.rx.text.orEmpty)
        }
        Observable.combineLatest(inputArray)
            .map { $0.map { !$0.isEmpty } }
            .map { $0.allSatisfy { $0 == true } }
            .subscribe(onNext: { [weak self] isValid in
                self?.updatePasswordButton(isEnabled: isValid)
            })
            .disposed(by: disposeBag)
    }

    private func setupPasswordButton() {
        updatePasswordButton.setStyle(to: .primary(state: .disabled, size: .large))
        updatePasswordButton.setTitleWithoutAnimation(R.string.localization.update_password_button_title.localized(), for: .normal)
        updatePasswordButton.addTarget(self, action: #selector(updatePasswordButtonDidTap), for: .touchUpInside)
        updatePasswordButton.isUserInteractionEnabled = false
    }

    @objc private func updatePasswordButtonDidTap() {
        closeKeyboard()

        guard newPasswordInputView.text == repeatePasswordInputView.text else {
            showAlert(title: "Password does not match")
            return
        }

        if let newPassword = newPasswordInputView.text {
            viewModel.changeDidTap(contactInputView.text ?? "", newPassword)
        }
    }

    private func setupViews() {
        passwordChangeRulesView.setBackgorundColor(to: .secondaryBg())
    }

    private func setupInputViewsObservation() {
        startObservingInputViewsReturn { [weak self] in
            guard self?.updatePasswordButton.isUserInteractionEnabled == true else {return}
            self?.updatePasswordButtonDidTap()
        }
    }

    @objc private func textFieldDidChange(_ textField: UITextField) {
        viewModel.newPasswordDidChange(to: textField.text ?? "")
    }

    // MARK: Configuration
    private func updatePasswordButton(isEnabled: Bool) {
        guard passwordChangeRulesView.allGood == true else {
            updatePasswordButton.isUserInteractionEnabled = false
            updatePasswordButton.setStyle(to: .primary(state: .disabled, size: .large))

            return
        }

        updatePasswordButton.isUserInteractionEnabled = isEnabled
        updatePasswordButton.setStyle(to: .primary(state: isEnabled ? .active : .disabled, size: .large))
    }

    private func updateRightButton(of passwordView: ABInputView) {
        let isSecureTextEntry = passwordView.mainTextField.isSecureTextEntry
        passwordView.toggleSecureTextEntry()

        let icon = isSecureTextEntry ? R.image.shared.viewText() : R.image.shared.hideText()
        passwordView.rightComponent.setImage(icon, for: .normal)
    }
}

extension PasswordResetViewController: InputViewsProviding {
    public var inputViews: [ABInputView] { [contactInputView, newPasswordInputView, repeatePasswordInputView] }
}

extension PasswordResetViewController: CommonBarButtonProviding { }

//Limit characters
extension PasswordResetViewController: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard viewModel.params.resetType == .sms else {return true}

        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count

        if count >= 12 {
            updatePasswordButton(isEnabled: true)
        } else {
            updatePasswordButton(isEnabled: false)
        }

        return (count >= 8 && count <= 12 ) //TODO number of characters in AM
    }
}
