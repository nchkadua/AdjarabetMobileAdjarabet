//
//  LoginViewController.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 5/11/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public class LoginViewController: ABViewController {
    public var viewModel: LoginViewModel!
    public lazy var navigator = LoginNavigator(viewController: self)

    // MARK: IBOutlets
    @IBOutlet private weak var scrollView: UIScrollView!

    @IBOutlet private weak var logoImageView: UIImageView!
    @IBOutlet private weak var qaButton: UIButton!

    @IBOutlet private weak var usernameInputView: ABInputView!
    @IBOutlet private weak var passwordInputView: ABInputView!
    @IBOutlet private weak var separatorView: UIView!
    @IBOutlet private weak var separatorView2: UIView!

    @IBOutlet private weak var smsLoginButton: ABButton!

    @IBOutlet private weak var loginButton: ABButton!
    @IBOutlet private weak var registrationButton: UIButton!

    @IBOutlet private weak var biometryIconButton: UIButton!
    @IBOutlet private weak var biometryButton: ABButton!

    @IBOutlet private weak var footerComponentView: FooterComponentView!
    private var passwordReminderComponentView: PasswordReminderComponentView?

    // MARK: Overrides
    public override var keyScrollView: UIScrollView? { scrollView }

    // MARK: - Lifecycle methods
    public override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        subscribeToPasswordInputView()
        bind(to: viewModel)
        viewModel.viewDidLoad()
        setupAccessibilityIdentifiers()
    }

    // MARK: Bind to viewModel's observable properties
    private func bind(to viewModel: LoginViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)

        viewModel.route.subscribe(onNext: { [weak self] route in
            self?.didRecive(route: route)
        }).disposed(by: disposeBag)
    }

    private func didRecive(action: LoginViewModelOutputAction) {
        switch action {
        case .setLoginButton(let isLoading):    setLoginButtonLoading(isLoading)
        case .setSmsLoginButton(let isLoading): smsLoginButton.set(isLoading: isLoading)
        case .setBiometryButton(let isLoading): biometryButton.set(isLoading: isLoading)
        case .configureBiometryButton(let available, let icon, let title):
            biometryButton.superview?.isHidden = !available
            biometryIconButton.setImage(icon, for: .normal)
            biometryButton.setTitleWithoutAnimation(title, for: .normal)
        case .configureQaButton(let image): setupQAButton(with: image)
        }
    }

    private func didRecive(route: LoginViewModelRoute) {
        switch route {
        case .openMainTabBar: navigator.navigate(to: .mainTabBar, animated: true)
        case .openOTP(let params): navigator.navigate(to: .OTP(params: params), animated: true)
        case .openAlert(let title, _): showAlert(title: title)
        }
    }

    // MAKR: Setup methods
    private func setup() {
        setBaseBackgorundColor(to: .secondaryBg())
        setupKeyboard()
        setupNavigationItem()
        setupScrollView()
        setupLogoImageView()
        setupButtons()
        setupInputViews()
        setupInputViewsObservation()
        setDelegates()
    }

    private func subscribeToPasswordInputView() {
        passwordInputView.rightComponent.rx.tap.subscribe(onNext: { [weak self] in
            self?.updatePasswordRightButton()
        }).disposed(by: disposeBag)
    }

    private func setupNavigationItem() {
        navigationController?.navigationBar.barTintColor = view.backgroundColor
    }

    private func setupScrollView() {
        scrollView.alwaysBounceVertical = true
    }

    private func setupLogoImageView() {
        logoImageView.image = R.image.login.logo()
    }

    private func setupButtons() {
        smsLoginButton.titleLabel?.setFont(to: .subHeadline(fontCase: .lower, fontStyle: .regular))
        smsLoginButton.setTitleColor(to: .primaryText(), for: .normal)
        smsLoginButton.setTitleColor(to: .secondaryText(), for: .highlighted)
        smsLoginButton.setTitleWithoutAnimation(R.string.localization.login_sms_login.localized(), for: .normal)
        smsLoginButton.addTarget(self, action: #selector(smsLoginDidTap), for: .touchUpInside)

        loginButton.setStyle(to: .primary(state: .active, size: .large))
        loginButton.setTitleWithoutAnimation(R.string.localization.login_button_title.localized(), for: .normal)
        loginButton.addTarget(self, action: #selector(loginDidTap), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginButtonTouchExit), for: .touchDragExit)
        loginButton.roundCorners(radius: 8)
//        updateLoginButton(isEnabled: false)

        registrationButton.titleLabel?.setFont(to: .callout(fontCase: .lower, fontStyle: .bold))
        registrationButton.setTitleColor(to: .primaryText(), for: .normal)
        registrationButton.backgroundColor = .clear
        registrationButton.setTitleWithoutAnimation(R.string.localization.login_registration.localized(), for: .normal)
        registrationButton.addTarget(self, action: #selector(registrationDidTap), for: .touchUpInside)
        registrationButton.roundCorners(radius: 41)

        biometryButton.titleLabel?.setFont(to: .subHeadline(fontCase: .lower, fontStyle: .regular))
        biometryButton.setTitleColor(to: .primaryText(), for: .normal)
        biometryButton.addTarget(self, action: #selector(biometryButtonDidTap), for: .touchUpInside)
        biometryIconButton.setTintColor(to: .primaryText())
        biometryIconButton.addTarget(self, action: #selector(biometryButtonDidTap), for: .touchUpInside)
    }

    private func setupInputViews() {
        usernameInputView.mainTextField.textContentType = .username
        usernameInputView.setPlaceholder(text: R.string.localization.login_username_input_title.localized())
        usernameInputView.setSize(to: .large)
        usernameInputView.setupWith(backgroundColor: .secondaryBg(), borderWidth: 0.0)

        passwordInputView.mainTextField.textContentType = .password
        passwordInputView.setPlaceholder(text: R.string.localization.login_password_input_title.localized())
        passwordInputView.setSize(to: .large)
        passwordInputView.setupWith(backgroundColor: .secondaryBg(), borderWidth: 0.0)
        passwordInputView.becomeSecureTextEntry()
        passwordInputView.setRightButtonImage(R.image.shared.hideText() ?? UIImage(), for: .normal)

        separatorView.setBackgorundColor(to: .nonOpaque())
        separatorView2.setBackgorundColor(to: .nonOpaque())

        Observable.combineLatest([usernameInputView.rx.text.orEmpty, passwordInputView.rx.text.orEmpty])
            .map { $0.map { !$0.isEmpty } }
            .map { $0.allSatisfy { $0 == true } }
            .subscribe(onNext: { [weak self] isValid in
                self?.updateLoginButton(isEnabled: isValid)
            })
            .disposed(by: disposeBag)

        //
        subscribeTo(usernameInputView, indicator: separatorView)
        subscribeTo(passwordInputView, indicator: separatorView2)

        setupPasswordReminderView()
    }

    private func subscribeTo(_ inputView: ABInputView, indicator: UIView) {
        inputView.mainTextField.rx.controlEvent([.editingDidBegin])
            .asObservable().subscribe({_ in
                UIView.animate(withDuration: 0.22) {
                    indicator.setBackgorundColor(to: .primaryText())
                }
            }).disposed(by: disposeBag)

        inputView.mainTextField.rx.controlEvent([.editingDidEnd])
            .asObservable().subscribe({_ in
                UIView.animate(withDuration: 0.22) {
                    indicator.setBackgorundColor(to: .nonOpaque())
                }
            }).disposed(by: disposeBag)
    }

    private func setupQAButton(with image: UIImage) {
        qaButton.setImage(image, for: .normal)
    }

    private func setupInputViewsObservation() {
        startObservingInputViewsReturn { [weak self] in
            guard self?.loginButton.isUserInteractionEnabled == true else {return}
            self?.loginDidTap()
        }
    }

    private func setupPasswordReminderView() {
        passwordReminderComponentView = PasswordReminderComponentView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 54))

        usernameInputView.mainTextField.inputAccessoryView = passwordReminderComponentView
        passwordInputView.mainTextField.inputAccessoryView = passwordReminderComponentView

        passwordReminderComponentView?.button.addTarget(self, action: #selector(navigateToPasswodReminder), for: .touchUpInside)
    }

    @objc private func navigateToPasswodReminder() {
        navigator.navigate(to: .passwordReset, animated: true)
    }

    @objc private func loginButtonTouchExit() {
        loginButton.setStyle(to: .primary(state: .active, size: .large))
    }

    private func setDelegates() {
        footerComponentView.delegate = self
    }

    // MARK: Actions
    @objc private func joinNowDidTap() {
        showAlert(title: "Join now")
    }

    @objc private func forgotPasswordDidTap() {
        showAlert(title: "Forgot Password")
    }

    @objc private func forgotUsernameDidTap() {
        showAlert(title: "Forgot Username")
    }

    @objc private func smsLoginDidTap() {
        guard let username = usernameInputView.mainTextField.text, !username.isEmpty else {
            showAlert(title: R.string.localization.fill_username.localized())
            return
        }

        closeKeyboard()
        viewModel.smsLogin(username: username)
    }

    @objc private func loginDidTap() {
        guard let username = usernameInputView.mainTextField.text, let password = passwordInputView.mainTextField.text else {return}

        closeKeyboard()
        viewModel.login(username: username, password: password)
    }

    @objc private func registrationDidTap() {
        closeKeyboard()
    }

    @objc private func biometryButtonDidTap() {
        viewModel.biometricLogin()
    }

    // MARK: Configuration
    private func updateLoginButton(isEnabled: Bool) {
        loginButton.isUserInteractionEnabled = isEnabled
        loginButton.setStyle(to: .primary(state: isEnabled ? .active : .disabled, size: .large))
    }

    private func updatePasswordRightButton() {
        let isSecureTextEntry = passwordInputView.mainTextField.isSecureTextEntry
        passwordInputView.toggleSecureTextEntry()

        let icon = isSecureTextEntry ? R.image.shared.viewText() : R.image.shared.hideText()
        passwordInputView.rightComponent.setImage(icon, for: .normal)
    }

    private func setLoginButtonLoading(_ loading: Bool) {
        loginButton.set(isLoading: loading)

        let title = loading ? "" : R.string.localization.login_button_title.localized()
        loginButton.setTitleWithoutAnimation(title, for: .normal)
    }
}

extension LoginViewController: InputViewsProviding {
    public var inputViews: [ABInputView] { [usernameInputView, passwordInputView] }
}

extension LoginViewController: FooterComponentViewDelegate {
    public func languageDidChange(language: Language) {
        setup()
        viewModel.languageDidChange()
    }
}

// MARK: Appium
//extension LoginViewController: Accessible { }

extension LoginViewController: Accessible {
    private func setupAccessibilityIdentifiers() {
        generateAccessibilityIdentifiers()
        usernameInputView.setAccessibilityIdTextfield(id: "LoginViewController.usernameInputTextField")
        passwordInputView.setAccessibilityIdTextfield(id: "LoginViewController.passwordInputTextField")

        usernameInputView.setAccessibilityIdsToPlaceholderLabels(id: "LoginViewController.usernameInputTextField.placeholder")
        passwordInputView.setAccessibilityIdsToPlaceholderLabels(id: "LoginViewController.passwordInputTextField.placeholder")

        footerComponentView.setAccessibilityIdToLAnguageButton("LoginViewController.languageButton")
    }
}
