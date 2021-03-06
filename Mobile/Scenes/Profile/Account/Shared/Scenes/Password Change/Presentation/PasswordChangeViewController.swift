//
//  PasswordChangeViewController.swift
//  Mobile
//
//  Created by Nika Chkadua on 11/25/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public class PasswordChangeViewController: ABViewController {
    @Inject(from: .viewModels) private var viewModel: PasswordChangeViewModel
    public lazy var navigator = PasswordChangeNavigator(viewController: self)

    // MARK: Outlets
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var oldPasswordInputView: ABInputView!
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
        errorThrowing = viewModel
        viewModel.viewDidLoad()
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        oldPasswordInputView.mainTextField.becomeFirstResponder()
    }

    // MARK: Bind to viewModel's observable properties
    private func bind(to viewModel: PasswordChangeViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)

        viewModel.route.subscribe(onNext: { [weak self] route in
            self?.didRecive(route: route)
        }).disposed(by: disposeBag)
    }

    private func didRecive(action: PasswordChangeViewModelOutputAction) {
        switch action {
        case .setButton(let loading): updatePasswordButton.set(isLoading: loading)
        case .updateRulesWithNewPassword(let newPassword): passwordChangeRulesView.updateRules(newPassword: newPassword)
        }
    }

    private func didRecive(route: PasswordChangeViewModelRoute) {
        switch route {
        case .openOTP(let params): navigator.navigate(to: .OTP(params: params), animated: true)
        }
    }

    // MARK: Setup methods
    private func setup() {
        setBaseBackgroundColor(to: .secondaryBg())
        setupNavigationItems()
        setupKeyboard()
        setupLabel()
        setupInputViews()
        setupInputViewsObservation()
        setupPasswordButton()
        setupViews()

        // {}() // TODO
        // setupAccessibilityIdentifiers()
    }

    private func setupNavigationItems() {
        let backButtonGroup = makeBackBarButtonItem(width: 60, title: R.string.localization.back_button_title.localized())
        navigationItem.leftBarButtonItem = backButtonGroup.barButtonItem
        backButtonGroup.button.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
    }

    @objc private func dismissViewController() {
        dismiss(animated: true, completion: nil)
    }

    private func setupLabel() {
        titleLabel.setFont(to: .title2(fontCase: .lower, fontStyle: .semiBold))
        titleLabel.setTextColor(to: .primaryText())
        titleLabel.text = R.string.localization.password_change_title.localized()
    }

    private func setupInputViews() {
        styleInputView(oldPasswordInputView, with: R.string.localization.old_password.localized())
        setupPasswordReminderView()

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

        Observable.combineLatest([oldPasswordInputView.rx.text.orEmpty, newPasswordInputView.rx.text.orEmpty, repeatePasswordInputView.rx.text.orEmpty])
            .map { $0.map { !$0.isEmpty } }
            .map { $0.allSatisfy { $0 == true } }
            .subscribe(onNext: { [weak self] isValid in
                self?.updatePasswordButton(isEnabled: isValid)
            })
            .disposed(by: disposeBag)
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

        if let oldPassword = oldPasswordInputView.text, let newPassword = newPasswordInputView.text {
            viewModel.changeDidTap(oldPassword, newPassword: newPassword)
        }
    }

    private func setupViews() {
        passwordChangeRulesView.setBackgorundColor(to: .secondaryBg())
    }

    private func setupPasswordReminderView() {
        passwordReminderComponentView = PasswordReminderComponentView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 54))
        oldPasswordInputView.mainTextField.inputAccessoryView = passwordReminderComponentView
        passwordReminderComponentView?.button.addTarget(self, action: #selector(navigateToPasswodReminder), for: .touchUpInside)
    }

    @objc private func navigateToPasswodReminder() {
        closeKeyboard()
        navigator.navigate(to: .passwordReset, animated: true)
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

extension PasswordChangeViewController: InputViewsProviding {
    public var inputViews: [ABInputView] { [oldPasswordInputView, newPasswordInputView, repeatePasswordInputView] }
}

extension PasswordChangeViewController: CommonBarButtonProviding { }
