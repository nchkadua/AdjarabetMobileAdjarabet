//
//  LoginViewController.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 5/11/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public class LoginViewController: UIViewController {
    public var viewModel: LoginViewModel = DefaultLoginViewModel(params: .init())
    public lazy var navigator = LoginNavigator(viewController: self)
    private let disposeBag = DisposeBag()

    // MARK: IBOutlets
    @IBOutlet public weak var loginTitleLabel: UILabel!
    @IBOutlet public weak var notMemberLabel: UILabel!
    @IBOutlet public weak var joinNowButton: ABButton!

    @IBOutlet public weak var usernameInputView: ABInputView!
    @IBOutlet public weak var passwordInputView: ABInputView!

    @IBOutlet public weak var forgotPasswordButton: ABButton!
    @IBOutlet public weak var forgotUsernameButton: ABButton!
    @IBOutlet public weak var smsLoginButton: ABButton!

    @IBOutlet public weak var loginButton: ABButton!

    // MARK: Overrides
    public override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    // MARK: - Lifecycle methods
    public override func viewDidLoad() {
        super.viewDidLoad()

        setBaseBackgorundColor()
        setupNavigationItem()
        setupLabels()
        setupButtons()
        setupInputViews()

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

        forgotPasswordButton.setSize(to: .none)
        forgotPasswordButton.setStyle(to: .textLink(state: .acvite))
        forgotPasswordButton.setTitleColor(to: .white(), for: .normal)
        forgotPasswordButton.setTitleWithoutAnimation("Forgot Password?", for: .normal)

        forgotUsernameButton.setSize(to: .none)
        forgotUsernameButton.setStyle(to: .textLink(state: .acvite))
        forgotUsernameButton.setTitleColor(to: .white(), for: .normal)
        forgotUsernameButton.setTitleWithoutAnimation("Forgot Username?", for: .normal)

        smsLoginButton.setSize(to: .none)
        smsLoginButton.setStyle(to: .textLink(state: .acvite))
        smsLoginButton.setTitleColor(to: .neutral100(alpha: 0.6), for: .normal)
        smsLoginButton.setTitleWithoutAnimation("SMS Login", for: .normal)

        loginButton.setSize(to: .large)
        loginButton.setStyle(to: .primary(state: .disabled))
        loginButton.setTitleWithoutAnimation("LOG IN", for: .normal)
    }

    private func setupInputViews() {
        usernameInputView.setPlaceholder(text: "username")
        usernameInputView.setSize(to: .large)

        passwordInputView.setPlaceholder(text: "password")
        passwordInputView.setSize(to: .large)
    }
}
