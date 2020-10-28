//
//  LoginViewController.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 5/11/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public class LoginViewController: ABViewController {
    public var viewModel: LoginViewModel = DefaultLoginViewModel(params: .init())
    public lazy var navigator = LoginNavigator(viewController: self)

    // MARK: IBOutlets
    @IBOutlet private weak var scrollView: UIScrollView!

    @IBOutlet private weak var loginTitleLabel: UILabel!
    @IBOutlet private weak var logoImageView: UIImageView!

    @IBOutlet private weak var usernameInputView: ABInputView!
    @IBOutlet private weak var passwordInputView: ABInputView!

    @IBOutlet private weak var smsLoginButton: ABButton!

    @IBOutlet private weak var loginButton: ABButton!

    @IBOutlet private weak var biometryIconButton: UIButton!
    @IBOutlet private weak var biometryButton: ABButton!

    @IBOutlet private weak var footerComponentView: FooterComponentView!

    // MARK: Overrides
    public override var keyScrollView: UIScrollView? { scrollView }

    // MARK: - Lifecycle methods
    public override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        observeKeyboardNotifications()
        addKeyboardDismissOnTap()

        bind(to: viewModel)
        viewModel.viewDidLoad()
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.viewDidAppear()
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
        case .setLoginButton(let isLoading):    loginButton.set(isLoading: isLoading)
        case .setSMSLoginButton(let isLoading): smsLoginButton.set(isLoading: isLoading)
        case .setBiometryButton(let isLoading): biometryButton.set(isLoading: isLoading)
        case .configureBiometryButton(let available, let icon, let title):
            biometryButton.superview?.isHidden = !available
            biometryIconButton.setImage(icon, for: .normal)
            biometryButton.setTitleWithoutAnimation(title, for: .normal)
        }
    }

    private func didRecive(route: LoginViewModelRoute) {
        switch route {
        case .openMainTabBar: navigator.navigate(to: .mainTabBar, animated: true)
        case .openSMSLogin(let params): navigator.navigate(to: .smsLogin(params: params), animated: true)
        case .openAlert(let title, _): showAlert(title: title)
        }
    }

    // MAKR: Setup methods
    private func setup() {
        setBaseBackgorundColor()
        setupNavigationItem()
        setupScrollView()
        setupLabels()
        setupLogoImageView()
        setupButtons()
        setupInputViews()
        setupInputViewsObservation()
        setDelegates()
    }

    private func setupNavigationItem() {
        navigationController?.navigationBar.barTintColor = view.backgroundColor
    }

    private func setupScrollView() {
        scrollView.alwaysBounceVertical = true
    }

    private func setupLabels() {
        loginTitleLabel.setTextColor(to: .systemWhite(alpha: 0.7))
        loginTitleLabel.setFont(to: .h4(fontCase: .lower))
        loginTitleLabel.text = R.string.localization.login_page_title.localized()
    }

    private func setupLogoImageView() {
        logoImageView.image = R.image.login.logo()
    }

    private func setupButtons() {
        smsLoginButton.setStyle(to: .textLink(state: .acvite, size: .small))
        smsLoginButton.setTitleColor(to: .separator(alpha: 0.6), for: .normal)
        smsLoginButton.setTitleWithoutAnimation(R.string.localization.login_sms_login.localized(), for: .normal)
        smsLoginButton.addTarget(self, action: #selector(smsLoginDidTap), for: .touchUpInside)
        updateSMSLoginButton(isEnabled: false)

        loginButton.setStyle(to: .primary(state: .disabled, size: .large))
        loginButton.setTitleWithoutAnimation(R.string.localization.login_button_title.localized(), for: .normal)
        loginButton.addTarget(self, action: #selector(loginDidTap), for: .touchUpInside)
        updateLoginButton(isEnabled: false)

        biometryButton.setStyle(to: .textLink(state: .acvite, size: .small))
        biometryButton.setTitleColor(to: .systemWhite(), for: .normal)
        biometryButton.setTitleWithoutAnimation(R.string.localization.login_sms_login.localized(), for: .normal)
        biometryButton.addTarget(self, action: #selector(biometryButtonDidTap), for: .touchUpInside)
        biometryIconButton.setTintColor(to: .systemWhite())
        biometryIconButton.addTarget(self, action: #selector(biometryButtonDidTap), for: .touchUpInside)
    }

    private func setupInputViews() {
        usernameInputView.mainTextField.textContentType = .username
        usernameInputView.setPlaceholder(text: R.string.localization.login_username_input_title.localized())
        usernameInputView.setSize(to: .large)

        passwordInputView.mainTextField.textContentType = .password
        passwordInputView.setPlaceholder(text: R.string.localization.login_password_input_title.localized())
        passwordInputView.setSize(to: .large)
        passwordInputView.becomeSecureTextEntry()

        passwordInputView.rightComponent.isHidden = false
        passwordInputView.rightComponent.setImage(R.image.shared.hideText(), for: .normal)

        passwordInputView.rightComponent.rx.tap.subscribe(onNext: { [weak self] in
            self?.updatePasswordRightButton()
        }).disposed(by: disposeBag)

        Observable.combineLatest([usernameInputView.rx.text.orEmpty, passwordInputView.rx.text.orEmpty])
            .map { $0.map { !$0.isEmpty } }
            .map { $0.allSatisfy { $0 == true } }
            .subscribe(onNext: { [weak self] isValid in
                self?.updateLoginButton(isEnabled: isValid)
            })
            .disposed(by: disposeBag)

        usernameInputView.rx.text.orEmpty
            .map { !$0.isEmpty }
            .subscribe(onNext: { [weak self] isValid in
                self?.updateSMSLoginButton(isEnabled: isValid)
            })
            .disposed(by: disposeBag)
    }

    private func setupInputViewsObservation() {
        startObservingInputViewsReturn { [weak self] in
            guard self?.loginButton.isUserInteractionEnabled == true else {return}
            self?.loginDidTap()
        }
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
        guard let username = usernameInputView.mainTextField.text else {return}

        closeKeyboard()
        viewModel.smsLogin(username: username)
    }

    @objc private func loginDidTap() {
        guard let username = usernameInputView.mainTextField.text, let password = passwordInputView.mainTextField.text else {return}

        closeKeyboard()
        viewModel.login(username: username, password: password)
    }

    @objc private func biometryButtonDidTap() {
        viewModel.biometricLogin()
    }

    // MARK: Configuration
    private func updateLoginButton(isEnabled: Bool) {
        loginButton.isUserInteractionEnabled = isEnabled
        loginButton.setStyle(to: .primary(state: isEnabled ? .acvite : .disabled, size: .large))
    }

    private func updateSMSLoginButton(isEnabled: Bool) {
        smsLoginButton.isUserInteractionEnabled = isEnabled
        smsLoginButton.setStyle(to: .textLink(state: isEnabled ? .acvite : .disabled, size: .small))
    }

    private func updatePasswordRightButton() {
        let isSecureTextEntry = passwordInputView.mainTextField.isSecureTextEntry
        passwordInputView.toggleSecureTextEntry()

        let icon = isSecureTextEntry ? R.image.shared.viewText() : R.image.shared.hideText()
        passwordInputView.rightComponent.setImage(icon, for: .normal)
    }
}

extension LoginViewController: InputViewsProviding {
    public var inputViews: [ABInputView] { [usernameInputView, passwordInputView] }
}

extension LoginViewController: FooterComponentViewDelegate {
    public func languageDidChange(language: Language) {
        setup()
    }
}
