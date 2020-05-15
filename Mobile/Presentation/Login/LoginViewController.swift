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
    @IBOutlet private weak var notMemberLabel: UILabel!
    @IBOutlet private weak var joinNowButton: ABButton!

    @IBOutlet private weak var usernameInputView: ABInputView!
    @IBOutlet private weak var passwordInputView: ABInputView!

    @IBOutlet private weak var forgotPasswordButton: ABButton!
    @IBOutlet private weak var forgotUsernameButton: ABButton!
    @IBOutlet private weak var smsLoginButton: ABButton!

    @IBOutlet private weak var loginButton: ABButton!

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

    // MARK: Bind to viewModel's observable properties
    private func bind(to viewModel: LoginViewModel) {
//        viewModel.action.subscribe(onNext: { [weak self] action in
//            self?.didRecive(action: action)
//        }).disposed(by: disposeBag)

        viewModel.route.subscribe(onNext: { [weak self] route in
            self?.didRecive(route: route)
        }).disposed(by: disposeBag)
    }

    private func didRecive(action: LoginViewModelOutputAction) {
    }

    private func didRecive(route: LoginViewModelRoute) {
        switch route {
        case .openSMSLogin(let params): navigator.navigate(to: .smsLogin(params: params), animated: true)
        }
    }

    // MAKR: Setup methods
    private func setup() {
        setBaseBackgorundColor()
        setupNavigationItem()
        setupScrollView()
        setupLabels()
        setupButtons()
        setupInputViews()
    }

    private func setupNavigationItem() {
        navigationController?.navigationBar.barTintColor = view.backgroundColor
    }

    private func setupScrollView() {
        scrollView.alwaysBounceVertical = true
    }

    private func setupLabels() {
        loginTitleLabel.setTextColor(to: .white())
        loginTitleLabel.setFont(to: .h2(fontCase: .lower))
        loginTitleLabel.text = "Log in"

        notMemberLabel.setTextColor(to: .neutral100(alpha: 0.6))
        notMemberLabel.setFont(to: .h4(fontCase: .lower))
        notMemberLabel.text = "Not a member?"
    }

    private func setupButtons() {
        joinNowButton.setSize(to: .medium)
        joinNowButton.setStyle(to: .ghost(state: .normal))
        joinNowButton.setTitleWithoutAnimation("Join now", for: .normal)
        joinNowButton.contentEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 0)
        joinNowButton.addTarget(self, action: #selector(joinNowDidTap), for: .touchUpInside)

        forgotPasswordButton.setSize(to: .none)
        forgotPasswordButton.setStyle(to: .textLink(state: .acvite))
        forgotPasswordButton.setTitleColor(to: .white(), for: .normal)
        forgotPasswordButton.setTitleWithoutAnimation("Forgot Password?", for: .normal)
        forgotPasswordButton.addTarget(self, action: #selector(forgotPasswordDidTap), for: .touchUpInside)

        forgotUsernameButton.setSize(to: .none)
        forgotUsernameButton.setStyle(to: .textLink(state: .acvite))
        forgotUsernameButton.setTitleColor(to: .white(), for: .normal)
        forgotUsernameButton.setTitleWithoutAnimation("Forgot Username?", for: .normal)
        forgotUsernameButton.addTarget(self, action: #selector(forgotUsernameDidTap), for: .touchUpInside)

        smsLoginButton.setSize(to: .none)
        smsLoginButton.setStyle(to: .textLink(state: .acvite))
        smsLoginButton.setTitleColor(to: .neutral100(alpha: 0.6), for: .normal)
        smsLoginButton.setTitleWithoutAnimation("SMS Login", for: .normal)
        smsLoginButton.addTarget(self, action: #selector(smsLoginDidTap), for: .touchUpInside)

        loginButton.setSize(to: .large)
        loginButton.setStyle(to: .primary(state: .disabled))
        loginButton.setTitleWithoutAnimation("LOG IN", for: .normal)
        loginButton.addTarget(self, action: #selector(loginDidTap), for: .touchUpInside)
        updateLoginButton(isEnabled: false)
    }

    private func setupInputViews() {
        usernameInputView.setPlaceholder(text: "username")
        usernameInputView.setSize(to: .large)

        passwordInputView.setPlaceholder(text: "password")
        passwordInputView.setSize(to: .large)
        passwordInputView.becomeSecureTextEntry()

        passwordInputView.rightButton.isHidden = false
        passwordInputView.rightButton.setImage(R.image.shared.viewText(), for: .normal)

        passwordInputView.rightButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.updatePasswordRightButton()
        }).disposed(by: disposeBag)

        Observable.combineLatest([usernameInputView.rx.text.orEmpty, passwordInputView.rx.text.orEmpty])
            .map { $0.map { !$0.isEmpty } }
            .map { $0.allSatisfy { $0 == true } }
            .subscribe(onNext: { [weak self] isValid in
                self?.updateLoginButton(isEnabled: isValid)
            })
            .disposed(by: disposeBag)
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
        closeKeyboard()
        viewModel.smsLogin()
    }

    @objc private func loginDidTap() {
        showAlert(title: "Log in")
    }

    // MARK: Configuration
    private func updateLoginButton(isEnabled: Bool) {
        loginButton.isUserInteractionEnabled = isEnabled
        loginButton.setStyle(to: .primary(state: isEnabled ? .acvite : .disabled))
    }

    private func updatePasswordRightButton() {
        let isSecureTextEntry = passwordInputView.textField.isSecureTextEntry
        passwordInputView.toggleSecureTextEntry()

        let icon = isSecureTextEntry ? R.image.shared.hideText() : R.image.shared.viewText()
        passwordInputView.rightButton.setImage(icon, for: .normal)
    }
}
