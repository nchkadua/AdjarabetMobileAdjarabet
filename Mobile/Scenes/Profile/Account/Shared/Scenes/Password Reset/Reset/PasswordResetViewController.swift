//
//  PasswordResetViewController.swift
//  Mobile
//
//  Created by Nika Chkadua on 30.06.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public class PasswordResetViewController: ABViewController {
    @Inject(from: .viewModels) public var viewModel: PasswordResetViewModel
    public lazy var navigator = PasswordResetNavigator(viewController: self)

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var phoneNumberInputView: ABInputView!
    @IBOutlet private weak var actionButton: ABButton!

    // MARK: - Lifecycle methods
    public override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }

    // MARK: Bind to viewModel's observable properties
    private func bind(to viewModel: PasswordResetViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)

        viewModel.route.subscribe(onNext: { [weak self] route in
            self?.didRecive(route: route)
        }).disposed(by: disposeBag)
    }

    private func didRecive(action: PasswordResetViewModelOutputAction) {
        switch action {
        case .setupPhoneNumber(let number):
            phoneNumberInputView.set(text: number)
            actionButton.set(isLoading: false)
        case .showMessage(let message):
            showAlert(title: message)
        }
    }

    private func didRecive(route: PasswordResetViewModelRoute) {
    }

    private func setup() {
        setBaseBackgorundColor(to: .secondaryBg())
        setupNavigationItems()
        setupKeyboard()
        setupLabels()
        setupInputViews()
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

    private func setupLabels() {
        titleLabel.setFont(to: .title2(fontCase: .lower, fontStyle: .semiBold))
        titleLabel.setTextColor(to: .primaryText())
        titleLabel.text = R.string.localization.reset_with_sms.localized()

        subtitleLabel.setFont(to: .footnote(fontCase: .lower, fontStyle: .semiBold))
        subtitleLabel.setTextColor(to: .secondaryText())
        subtitleLabel.text = R.string.localization.reset_password_hint.localized()
    }

    private func setupInputViews() {
        phoneNumberInputView.setupWith(backgroundColor: .querternaryFill(), borderWidth: 0, hidesPlaceholder: true)
        phoneNumberInputView.mainTextField.setFont(to: .title3(fontCase: .lower, fontStyle: .regular))
        phoneNumberInputView.mainTextField.textAlignment = .center
        phoneNumberInputView.mainTextField.keyboardType = .numberPad
    }

    private func setupButtons() {
        actionButton.setStyle(to: .primary(state: .disabled, size: .large))
        actionButton.setTitleWithoutAnimation(R.string.localization.reset_password_send_code.localized(), for: .normal)
        actionButton.addTarget(self, action: #selector(actionButtonDidTap), for: .touchUpInside)
        //Start loading immediately
        actionButton.set(isLoading: true)
    }

    @objc private func actionButtonDidTap() {
        closeKeyboard()
    }

    // MARK: Configuration
    private func updateActionButton(isEnabled: Bool) {
        actionButton.isUserInteractionEnabled = isEnabled
        actionButton.setStyle(to: .primary(state: isEnabled ? .active : .disabled, size: .large))
    }
}

extension PasswordResetViewController: CommonBarButtonProviding { }
