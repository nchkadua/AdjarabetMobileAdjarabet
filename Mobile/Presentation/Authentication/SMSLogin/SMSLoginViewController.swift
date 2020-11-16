//
//  SMSLoginViewController.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 5/13/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public class SMSLoginViewController: ABViewController {
    public var viewModel: SMSLoginViewModel!
    public lazy var navigator = SMSLoginNavigator(viewController: self)

    // MARK: IBOutlets
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var smsLoginDescriptionLabel: UILabel!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var resendSMSButton: ABButton!
    @IBOutlet private weak var smsCodeInputView: SMSCodeInputView!
    @IBOutlet private weak var loginButton: ABButton!

    private lazy var smsCodeTextField: UITextField = {
        let f = UITextField()
        f.translatesAutoresizingMaskIntoConstraints = false
        f.keyboardType = .asciiCapableNumberPad
        f.delegate = self
        f.isHidden = true
        f.alpha = 0
        f.textContentType = .oneTimeCode
        return f
    }()

    // MARK: - Lifecycle methods
    public override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        smsCodeTextField.becomeFirstResponder()
    }

    // MARK: Bind to viewModel's observable properties
    private func bind(to viewModel: SMSLoginViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)

        viewModel.route.subscribe(onNext: { [weak self] route in
            self?.didRecive(route: route)
        }).disposed(by: disposeBag)
    }

    private func didRecive(action: SMSLoginViewModelOutputAction) {
        switch action {
        case .setSMSInputViewNumberOfItems(let count): smsCodeInputView.configureForNumberOfItems(count)
        case .setSMSCodeInputView(let text): updateSMSCodeInputView(texts: text)
        case .setResendSMSButton(let isLoading): resendSMSButton.set(isLoading: isLoading)
        case .setLoginButton(let isLoading): loginButton.set(isLoading: isLoading)
        }
    }

    private func didRecive(route: SMSLoginViewModelRoute) {
        switch route {
        case .showSuccessMessage: showSuccessMessage()
        case .openMainTabBar: navigator.navigate(to: .mainTabBar, animated: true)
        case .showErrorMessage(let title, _): showErrorMessage(title)
        }
    }

    // MAKR: Setup methods
    private func setup() {
        setBaseBackgorundColor()
        setupKeyboard()
        setupNavigationItem()
        setupScrollView()
        setupLabels()
        setupButtons()
        setupSMSCodeInputView()
    }

    private func setupNavigationItem() {
        setTitle(title: R.string.localization.sms_login_page_title.localized())
        setBackBarButtonItemIfNeeded(width: 44, rounded: true)
        navigationController?.navigationBar.barTintColor = view.backgroundColor
    }

    private func setupScrollView() {
        scrollView.alwaysBounceVertical = true
        scrollView.isScrollEnabled = false
    }

    private func setupLabels() {
        smsLoginDescriptionLabel.setTextColor(to: .primaryRed())
        smsLoginDescriptionLabel.setFont(to: .p)

        let smsLoginDescription = R.string.localization.sms_confirmation_description.localized()
            .makeAttributedString(with: .caption2(fontCase: .lower),
                                  lineSpasing: 4,
                                  foregroundColor: .secondaryText())
        smsLoginDescriptionLabel.attributedText = smsLoginDescription

        messageLabel.setTextColor(to: .secondaryText())
        messageLabel.setFont(to: .caption2(fontCase: .lower))
        messageLabel.text = R.string.localization.sms_did_not_receive_message()
    }

    private func setupButtons() {
        resendSMSButton.setStyle(to: .textLink(state: .acvite, size: .small))
        resendSMSButton.setTitleColor(to: .primaryText(), for: .normal)
        resendSMSButton.setTitleWithoutAnimation(R.string.localization.sms_resend.localized(), for: .normal)
        resendSMSButton.setImage(R.image.smsLogin.resend(), for: .normal)
        resendSMSButton.imageEdgeInsets = .init(top: 0, left: -5, bottom: 0, right: 5)
        resendSMSButton.contentEdgeInsets = .init(top: 0, left: 5, bottom: 0, right: 0)
        resendSMSButton.addTarget(self, action: #selector(resendSMSDidTap), for: .touchUpInside)
        updateLoginButtonWhen(smsCodeText: nil, animated: false)

        loginButton.setStyle(to: .tertiary(state: .disabled, size: .large))
        loginButton.setTitleWithoutAnimation(R.string.localization.login_button_title.localized(), for: .normal)
        loginButton.addTarget(self, action: #selector(loginDidTap), for: .touchUpInside)
    }

    private func setupSMSCodeInputView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(showKeyboard))
        smsCodeInputView.addGestureRecognizer(tap)

        smsCodeInputView.addSubview(smsCodeTextField)
        smsCodeTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

        smsCodeInputView.configureForNumberOfItems(6)
    }

    // MARK: Actions
    @objc private func showKeyboard() {
        smsCodeTextField.becomeFirstResponder()
    }

    @objc private func joinNowDidTap() {
        showAlert(title: "Join now")
    }

    @objc private func resendSMSDidTap() {
        viewModel.resendSMS()
    }

    @objc private func loginDidTap() {
        guard let code = smsCodeTextField.text else {return}

        closeKeyboard()
        viewModel.login(code: code)
    }

    @objc private func textFieldDidChange(_ textField: UITextField) {
        viewModel.textDidChange(to: textField.text)
        updateLoginButtonWhen(smsCodeText: textField.text, animated: true)
    }

    private func showErrorMessage(_ message: String) {
        messageLabel.setTextColor(to: .systemRed300())
        messageLabel.text = message
    }

    private func showSuccessMessage() {
        messageLabel.setTextColor(to: .systemGreen150())
        messageLabel.setTextAndImage(R.string.localization.sms_well_done(), R.image.login.well_done()!, alignment: .right)
    }

    // MARK: Configuration
    private func updateSMSCodeInputView(texts: [String?]) {
        texts.enumerated().forEach { index, text in
            smsCodeInputView[index].setText(text, animationDuration: 0.2)
        }
    }

    private func updateLoginButtonWhen(smsCodeText: String?, animated animate: Bool) {
        let isEnabled = viewModel.shoudEnableLoginButton(fot: smsCodeText)
        loginButton.isUserInteractionEnabled = isEnabled

        loginButton.setStyle(to: .tertiary(state: isEnabled ? .acvite : .disabled, size: .large))
    }
}

// MAKR: UITextFieldDelegate
extension SMSLoginViewController: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let result = ((textField.text ?? "") as NSString).replacingCharacters(in: range, with: string)

        return viewModel.shouldChangeCharacters(for: result)
    }
}
