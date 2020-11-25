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
        bind(to: viewModel)
        viewModel.viewDidLoad()
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
    }

    private func didRecive(action: MailChangeViewModelOutputAction) {
    }

    // MARK: Setup methods
    private func setup() {
        setBaseBackgorundColor(to: .secondaryBg())
        setupNavigationItems()
        setupKeyboard()
        setupInputViews()
        setupInputViewsObservation()
        setupButtons()
        setupLabel()
    }

    private func setupNavigationItems() {
        setTitle(title: R.string.localization.mail_change_title.localized())
    }

    private func setupInputViews() {
        mailInputView.mainTextField.keyboardType = .emailAddress
        mailInputView.setupWith(backgroundColor: .querternaryFill(), borderWidth: 0)
        mailInputView.setPlaceholder(text: R.string.localization.new_mail_title.localized())

        passwordInputView.setupWith(backgroundColor: .querternaryFill(), borderWidth: 0)
        passwordInputView.mainTextField.textContentType = .password
        passwordInputView.setPlaceholder(text: R.string.localization.login_password_input_title.localized())
        passwordInputView.setSize(to: .large)
        passwordInputView.becomeSecureTextEntry()
        passwordInputView.rightComponent.isHidden = false
        passwordInputView.rightComponent.setImage(R.image.shared.hideText(), for: .normal)

        passwordInputView.rightComponent.rx.tap.subscribe(onNext: { [weak self] in
            self?.updatePasswordRightButton()
        }).disposed(by: disposeBag)
    }

    private func setupInputViewsObservation() {
        startObservingInputViewsReturn { [weak self] in
            guard self?.changeButton.isUserInteractionEnabled == true else {return}
            self?.changeMailDidTap()
        }
    }

    private func updatePasswordRightButton() {
        let isSecureTextEntry = passwordInputView.mainTextField.isSecureTextEntry
        passwordInputView.toggleSecureTextEntry()

        let icon = isSecureTextEntry ? R.image.shared.viewText() : R.image.shared.hideText()
        passwordInputView.rightComponent.setImage(icon, for: .normal)
    }

    private func setupButtons() {
        changeButton.setStyle(to: .tertiary(state: .acvite, size: .large))
        changeButton.setTitleWithoutAnimation(R.string.localization.change_mail_button_title.localized(), for: .normal)
        changeButton.addTarget(self, action: #selector(changeMailDidTap), for: .touchUpInside)
    }

    @objc private func changeMailDidTap() {
        closeKeyboard()
    }

    private func setupLabel() {
        titleLabel.setFont(to: .footnote(fontCase: .lower))
        titleLabel.setTextColor(to: .secondaryText())
        titleLabel.text = "\("•")   \(R.string.localization.approve_password.localized())"
    }
}

extension MailChangeViewController: InputViewsProviding {
    public var inputViews: [ABInputView] { [mailInputView, passwordInputView] }
}
