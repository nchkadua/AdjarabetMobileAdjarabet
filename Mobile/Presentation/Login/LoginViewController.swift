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
    public override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    public override var keyScrollView: UIScrollView? { scrollView }

    // MARK: - Lifecycle methods
    public override func viewDidLoad() {
        super.viewDidLoad()

        setBaseBackgorundColor()
        setupNavigationItem()
        setupScrollView()
        setupLabels()
        setupButtons()
        setupInputViews()
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
//
//        viewModel.route.subscribe(onNext: { [weak self] route in
//            self?.didRecive(route: route)
//        }).disposed(by: disposeBag)
    }

    private func didRecive(action: LoginViewModelOutputAction) {
    }

    private func didRecive(route: LoginViewModelRoute) {
    }

    // MAKR: Setup methods
    private func setupNavigationItem() {
        navigationController?.navigationBar.barTintColor = view.backgroundColor
    }

    private func setupScrollView() {
//        scrollView.keyboardDismissMode = .interactive
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
        joinNowButton.setStyle(to: .ghost(state: .acvite))
        joinNowButton.setTitleWithoutAnimation("Join now", for: .normal)
        joinNowButton.contentEdgeInsets = .zero
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
    }

    private func setupInputViews() {
        usernameInputView.setPlaceholder(text: "username")
        usernameInputView.setSize(to: .large)

        passwordInputView.setPlaceholder(text: "password")
        passwordInputView.setSize(to: .large)
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
        showAlert(title: "SMS Login")
    }

    @objc private func loginDidTap() {
        showAlert(title: "Log in")
    }
}
