//
//  MailChangeViewController.swift
//  Mobile
//
//  Created by Nika Chkadua on 11/24/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public class MailChangeViewController: ABViewController {
    @Inject(from: .viewModels) private var viewModel: MailChangeViewModel
    public lazy var navigator = MailChangeNavigator(viewController: self)

    // MARK: Outlets
    @IBOutlet private weak var mailInputView: ABInputView!
    @IBOutlet private weak var passwordInputView: ABInputView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var changeButton: ABButton!

    // MARK: - Lifecycle methods
    public override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        subscribeToPasswordInputView()
        bind(to: viewModel)
        viewModel.viewDidLoad()
        setupAccessibilityIdentifiers()
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mailInputView.mainTextField.becomeFirstResponder()
    }

    // MARK: Bind to viewModel's observable properties
    private func bind(to viewModel: MailChangeViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)

        viewModel.route.subscribe(onNext: { [weak self] route in
            self?.didRecive(route: route)
        }).disposed(by: disposeBag)
    }

    private func didRecive(action: MailChangeViewModelOutputAction) {
        switch action {
        case .setButton(let loading): changeButton.set(isLoading: loading)
        case .showMessage(let message): showAlert(title: message)
        }
    }

    private func didRecive(route: MailChangeViewModelRoute) {
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
        setupButtons()
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
        titleLabel.text = R.string.localization.mail_change_title.localized()
    }

    private func setupInputViews() {
        mailInputView.mainTextField.keyboardType = .emailAddress
        mailInputView.setupWith(backgroundColor: .querternaryFill(), borderWidth: 0)
        mailInputView.setPlaceholder(text: R.string.localization.new_mail_title.localized())

        passwordInputView.mainTextField.textContentType = .password
        passwordInputView.setupWith(backgroundColor: .querternaryFill(), borderWidth: 0)
        passwordInputView.setPlaceholder(text: R.string.localization.mail_change_password.localized())
        passwordInputView.becomeSecureTextEntry()
        passwordInputView.setRightButtonImage(R.image.shared.hideText() ?? UIImage(), for: .normal)

        Observable.combineLatest([mailInputView.rx.text.orEmpty, passwordInputView.rx.text.orEmpty])
            .map { $0.map { !$0.isEmpty } }
            .map { $0.allSatisfy { $0 == true } }
            .subscribe(onNext: { [weak self] isValid in
                self?.updateChangeButton(isEnabled: isValid)
            })
            .disposed(by: disposeBag)
    }

    private func subscribeToPasswordInputView() {
        passwordInputView.rightComponent.rx.tap.subscribe(onNext: { [weak self] in
            self?.updatePasswordRightButton()
        }).disposed(by: disposeBag)
    }

    private func updatePasswordRightButton() {
        let isSecureTextEntry = passwordInputView.mainTextField.isSecureTextEntry
        passwordInputView.toggleSecureTextEntry()

        let icon = isSecureTextEntry ? R.image.shared.viewText() : R.image.shared.hideText()
        passwordInputView.rightComponent.setImage(icon, for: .normal)
    }

    private func setupInputViewsObservation() {
        startObservingInputViewsReturn { [weak self] in
            guard self?.changeButton.isUserInteractionEnabled == true else {return}
            self?.changeMailDidTap()
        }
    }

    private func setupButtons() {
        changeButton.setStyle(to: .primary(state: .disabled, size: .large))
        changeButton.setTitleWithoutAnimation(R.string.localization.change_mail_button_title.localized(), for: .normal)
        changeButton.addTarget(self, action: #selector(changeMailDidTap), for: .touchUpInside)
    }

    @objc private func changeMailDidTap() {
        closeKeyboard()
        viewModel.updateMail(mailInputView.text ?? "", passwordInputView.text ?? "")
    }

    // MARK: Configuration
    private func updateChangeButton(isEnabled: Bool) {
        changeButton.isUserInteractionEnabled = isEnabled
        changeButton.setStyle(to: .primary(state: isEnabled ? .active : .disabled, size: .large))
    }
}

extension MailChangeViewController: InputViewsProviding {
    public var inputViews: [ABInputView] { [mailInputView] }
}

// MARK: Accessibility Identifiers
extension MailChangeViewController: Accessible {
    private func setupAccessibilityIdentifiers() {
        generateAccessibilityIdentifiers()

        changeButton.accessibilityIdentifier = "MailChangeViewController.changeButton"
        navigationItem.titleView?.accessibilityIdentifier = "MailChangeViewController.title"
    }
}

extension MailChangeViewController: CommonBarButtonProviding { }
