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
    @IBOutlet private weak var oldPasswordInputView: ABInputView!
    @IBOutlet private weak var newPasswordInputView: ABInputView!
    @IBOutlet private weak var repeatePasswordInputView: ABInputView!
    @IBOutlet private weak var updatePasswordButton: ABButton!
    @IBOutlet private weak var passwordChangeRulesView: PasswordChangeRulesView!

    // MARK: - Lifecycle methods
    public override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        bind(to: viewModel)
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
    }

    private func didRecive(action: PasswordChangeViewModelOutputAction) {
        switch action {
        case .updateRulesWithNewPassword(let newPassword): passwordChangeRulesView.updateRules(newPassword: newPassword)
        }
    }

    // MARK: Setup methods
    private func setup() {
        setBaseBackgorundColor(to: .secondaryBg())
        setupNavigationItems()
        setupKeyboard()
        setupInputViews()
        setupInputViewsObservation()
        setupPasswordButton()
        setupViews()
    }

    private func setupNavigationItems() {
        setTitle(title: R.string.localization.password_change_title.localized())
    }

    private func setupInputViews() {
        styleInputView(oldPasswordInputView, with: R.string.localization.old_password.localized())

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

    private func updateRightButton(of passwordView: ABInputView) {
        let isSecureTextEntry = passwordView.mainTextField.isSecureTextEntry
        passwordView.toggleSecureTextEntry()

        let icon = isSecureTextEntry ? R.image.shared.viewText() : R.image.shared.hideText()
        passwordView.rightComponent.setImage(icon, for: .normal)
    }

    private func setupPasswordButton() {
        updatePasswordButton.setStyle(to: .tertiary(state: .acvite, size: .large))
        updatePasswordButton.setTitleWithoutAnimation(R.string.localization.update_password_button_title.localized(), for: .normal)
        updatePasswordButton.addTarget(self, action: #selector(updatePasswordButtonDidTap), for: .touchUpInside)
    }

    @objc private func updatePasswordButtonDidTap() {
        closeKeyboard()
    }

    private func setupViews() {
        passwordChangeRulesView.setBackgorundColor(to: .secondaryBg())
    }
}

extension PasswordChangeViewController: InputViewsProviding {
    public var inputViews: [ABInputView] { [oldPasswordInputView, newPasswordInputView, repeatePasswordInputView] }
}
