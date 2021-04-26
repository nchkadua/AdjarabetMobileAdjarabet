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
    @IBOutlet private weak var smsCodeInputView: SMSCodeInputView!
    @IBOutlet private weak var placeholderLabel: UILabel!
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
        case .setLoginButton(let isLoading): loginButton.set(isLoading: isLoading)
        case .bindToTimer(let timerViewModel): bindToTimer(timerViewModel)
        default:
            break
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
        setTitle(title: title.uppercased())

        guard showDismissButton else { return }

        setDismissBarButtonItemIfNeeded()
        navigationController?.navigationBar.barTintColor = view.backgroundColor
    }

    private func setupScrollView() {
        scrollView.alwaysBounceVertical = true
        scrollView.isScrollEnabled = false
    }

    private func setupLabels() {
        otpDescriptionLabel.textAlignment = .center
        otpDescriptionLabel.setFont(to: .footnote(fontCase: .lower, fontStyle: .regular))

        let OTPDescription = R.string.localization.sms_confirmation_description.localized()
            .makeAttributedString(with: .footnote(fontCase: .lower, fontStyle: .regular),
                                  lineSpasing: 4,
                                  foregroundColor: .secondaryText())
        otpDescriptionLabel.attributedText = OTPDescription

        placeholderLabel.setFont(to: .subHeadline(fontCase: .lower, fontStyle: .regular))
        placeholderLabel.setTextColor(to: .secondaryText())
        placeholderLabel.text = R.string.localization.sms_placeholder.localized()
    }

    private func setupButtons() {
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
        smsCodeInputView.roundCorners(.allCorners, radius: 6)
    }

    /// Timer
    private func bindToTimer(_ timerViewModel: TimerComponentViewModel) {
        timerView.setAndBind(viewModel: timerViewModel)
        bind(to: timerViewModel)
        viewModel.didBindToTimer()
        timerView.button.addTarget(self, action: #selector(resendDidTap), for: .touchUpInside)
    }

    private func bind(to viewModel: TimerComponentViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)
    }

    private func didRecive(action: TimerComponentViewModelOutputAction) {
        switch action {
        default:
            break
        }
    }

    @objc private func resendDidTap() {
        viewModel.restartTimer()
        viewModel.resendSMS()
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

    private func updatePlaceholder(_ hide: Bool) {
        UIView.animate(withDuration: 0.22) {
            self.placeholderLabel.isHidden = hide
        }
    }
}

// MAKR: UITextFieldDelegate
extension OTPViewController: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let result = ((textField.text ?? "") as NSString).replacingCharacters(in: range, with: string)

        updatePlaceholder(result.count >= 1)
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
     //   resendSMSButton.accessibilityIdentifier = "OTPViewController.resendSMSButton"
        otpDescriptionLabel.accessibilityIdentifier = "OTPViewController.otpDescriptionLabel"
        smsCodeTextField.accessibilityIdentifier = "OTPViewController.smsCodeTextField"
        smsCodeInputView.accessibilityIdentifier = "OTPViewController.smsCodeInputView"
    }
}
