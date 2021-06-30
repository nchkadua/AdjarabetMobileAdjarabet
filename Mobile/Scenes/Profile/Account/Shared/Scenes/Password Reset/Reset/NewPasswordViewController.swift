//
//  NewPasswordViewController.swift
//  Mobile
//
//  Created by Nika Chkadua on 30.06.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public class NewPasswordViewController: ABViewController {
    @Inject(from: .viewModels) public var viewModel: NewPasswordViewModel
    public lazy var navigator = NewPasswordNavigator(viewController: self)

    @IBOutlet private weak var titleLabel: UILabel!
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
        newPasswordInputView.mainTextField.becomeFirstResponder()
    }

    // MARK: Bind to viewModel's observable properties
    private func bind(to viewModel: NewPasswordViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)

        viewModel.route.subscribe(onNext: { [weak self] route in
            self?.didRecive(route: route)
        }).disposed(by: disposeBag)
    }

    private func didRecive(action: NewPasswordViewModelOutputAction) {
    }

    private func didRecive(route: NewPasswordViewModelRoute) {
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
        styleInputView(repeatePasswordInputView, with: R.string.localization.old_password.localized())

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

        Observable.combineLatest([repeatePasswordInputView.rx.text.orEmpty, newPasswordInputView.rx.text.orEmpty, repeatePasswordInputView.rx.text.orEmpty])
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
//        viewModel.newPasswordDidChange(to: textField.text ?? "")
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

extension NewPasswordViewController: InputViewsProviding {
    public var inputViews: [ABInputView] { [newPasswordInputView, repeatePasswordInputView] }
}

extension NewPasswordViewController: CommonBarButtonProviding { }
