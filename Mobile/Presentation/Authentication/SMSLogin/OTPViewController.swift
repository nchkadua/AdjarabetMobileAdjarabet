//
//  OTPViewController.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 5/13/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public class OTPViewController: ABViewController {
    @Inject(from: .viewModels) public var viewModel: OTPViewModel
    public lazy var navigator = OTPNavigator(viewController: self)

    // MARK: IBOutlets
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var otpDescriptionLabel: UILabel!
    @IBOutlet private weak var resendSMSButton: ABButton!
    @IBOutlet private weak var smsCodeInputView: SMSCodeInputView!
    @IBOutlet private weak var loginButton: ABButton!
    @IBOutlet private weak var timerView: TimerComponentView!

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
        setupAccessibilityIdentifiers()
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        smsCodeTextField.becomeFirstResponder()
    }

    // MARK: Bind to viewModel's observable properties
    private func bind(to viewModel: OTPViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)

        viewModel.route.subscribe(onNext: { [weak self] route in
            self?.didRecive(route: route)
        }).disposed(by: disposeBag)
    }

    private func didRecive(action: OTPViewModelOutputAction) {
        switch action {
        case .setNavigationItems(let title, let showDismissButton): setupNavigationItems(title, showDismissButton: showDismissButton)
        case .setButtonTitle(let title): setButtonTitle(title)
        case .setSMSInputViewNumberOfItems(let count): smsCodeInputView.configureForNumberOfItems(count)
        case .setSMSCodeInputView(let text): updateSMSCodeInputView(texts: text)
        case .setResendSMSButton(let isLoading): resendSMSButton.set(isLoading: isLoading)
        case .setLoginButton(let isLoading): loginButton.set(isLoading: isLoading)
        case .bindToTimer(let timerViewModel): bindToTimer(timerViewModel)
        }
    }

    private func didRecive(route: OTPViewModelRoute) {
        switch route {
        case .openMainTabBar: navigator.navigate(to: .mainTabBar, animated: true)
        default:
            break
        }
    }

    // MAKR: Setup methods
    private func setup() {
        setBaseBackgorundColor()
        setupKeyboard()
        setupScrollView()
        setupLabels()
        setupButtons()
        setupSMSCodeInputView()
    }

    private func setupNavigationItems(_ title: String, showDismissButton: Bool) {
        setTitle(title: title)

        guard showDismissButton else { return }

        setDismissBarButtonItemIfNeeded(width: 44)
        navigationController?.navigationBar.barTintColor = view.backgroundColor
    }

    private func setupScrollView() {
        scrollView.alwaysBounceVertical = true
        scrollView.isScrollEnabled = false
    }

    private func setupLabels() {
        otpDescriptionLabel.textAlignment = .center
        otpDescriptionLabel.setTextColor(to: .primaryRed())
        otpDescriptionLabel.setFont(to: .caption2(fontCase: .lower))

        let OTPDescription = R.string.localization.sms_confirmation_description.localized()
            .makeAttributedString(with: .caption2(fontCase: .lower),
                                  lineSpasing: 4,
                                  foregroundColor: .secondaryText())
        otpDescriptionLabel.attributedText = OTPDescription
    }

    private func setupButtons() {
        resendSMSButton.setImage(R.image.otP.resend() ?? UIImage(), tintColor: .primaryText())
        resendSMSButton.setStyle(to: .textLink(state: .disabled, size: .small))
        resendSMSButton.setTitleColor(to: .primaryText(), for: .normal)
        resendSMSButton.setTitleWithoutAnimation(R.string.localization.sms_resend.localized(), for: .normal)
        resendSMSButton.addTarget(self, action: #selector(resendSMSDidTap), for: .touchUpInside)
        resendSMSButton.isUserInteractionEnabled = false
        updateLoginButtonWhen(smsCodeText: nil, animated: false)

        loginButton.setStyle(to: .primary(state: .disabled, size: .large))
        loginButton.addTarget(self, action: #selector(loginDidTap), for: .touchUpInside)
    }

    private func setButtonTitle(_ title: String) {
        loginButton.setTitleWithoutAnimation(title, for: .normal)
    }

    private func setupSMSCodeInputView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(showKeyboard))
        smsCodeInputView.addGestureRecognizer(tap)

        smsCodeInputView.addSubview(smsCodeTextField)
        smsCodeTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

        smsCodeInputView.configureForNumberOfItems(6)
    }

    /// Timer
    private func bindToTimer(_ timerViewModel: TimerComponentViewModel) {
        timerView.setAndBind(viewModel: timerViewModel)
        bind(to: timerViewModel)
        viewModel.didBindToTimer()
    }

    private func bind(to viewModel: TimerComponentViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)
    }

    private func didRecive(action: TimerComponentViewModelOutputAction) {
        switch action {
        case .timerDidEnd: updateResendButton(activate: true)
        default:
            break
        }
    }

    // MARK: Actions
    @objc private func showKeyboard() {
        smsCodeTextField.becomeFirstResponder()
    }

    @objc private func joinNowDidTap() {
        showAlert(title: "Join now")
    }

    @objc private func resendSMSDidTap() {
        viewModel.restartTimer()
        viewModel.resendSMS()
        updateResendButton(activate: false)
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

    // MARK: Configuration
    private func updateSMSCodeInputView(texts: [String?]) {
        texts.enumerated().forEach { index, text in
            smsCodeInputView[index].setText(text, animationDuration: 0.2)
        }
    }

    private func updateLoginButtonWhen(smsCodeText: String?, animated animate: Bool) {
        let isEnabled = viewModel.shoudEnableLoginButton(fot: smsCodeText)
        loginButton.isUserInteractionEnabled = isEnabled

        loginButton.setStyle(to: .primary(state: isEnabled ? .active : .disabled, size: .large))
    }

    private func updateResendButton(activate: Bool) {
        if activate {
            resendSMSButton.setStyle(to: .textLink(state: .active, size: .small))
            resendSMSButton.setImage(R.image.otP.resend() ?? UIImage(), tintColor: .systemRed())
            resendSMSButton.isUserInteractionEnabled = true
        } else {
            resendSMSButton.setStyle(to: .textLink(state: .disabled, size: .small))
            resendSMSButton.setImage(R.image.otP.resend() ?? UIImage(), tintColor: .primaryText())
            resendSMSButton.isUserInteractionEnabled = false
        }
    }
}

// MAKR: UITextFieldDelegate
extension OTPViewController: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let result = ((textField.text ?? "") as NSString).replacingCharacters(in: range, with: string)

        return viewModel.shouldChangeCharacters(for: result)
    }
}

extension OTPViewController: InputViewsProviding {
    public var inputViews: [ABInputView] { [] }
}

// MARK: Accessibility Identifiers
extension OTPViewController: Accessible {
    private func setupAccessibilityIdentifiers() {
        generateAccessibilityIdentifiers()


        loginButton.accessibilityIdentifier = "OTPViewController.loginButton"
        resendSMSButton.accessibilityIdentifier = "OTPViewController.resendSMSButton"
        otpDescriptionLabel.accessibilityIdentifier = "OTPViewController.otpDescriptionLabel"
        smsCodeTextField.accessibilityIdentifier = "OTPViewController.smsCodeTextField"
        smsCodeInputView.accessibilityIdentifier = "OTPViewController.smsCodeInputView"
    }
}
