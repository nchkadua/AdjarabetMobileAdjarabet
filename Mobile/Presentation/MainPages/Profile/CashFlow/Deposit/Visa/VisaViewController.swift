//
//  VisaViewController.swift
//  Mobile
//
//  Created by Nika Chkadua on 3/23/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public class VisaViewController: ABViewController {
    var viewModel: VisaViewModel!
    private lazy var navigator = VisaNavigator(viewController: self)

    // MARK: Outlets
    @IBOutlet weak private var paymentContainerView: UIView!
    @IBOutlet weak private var amountInputView: ABInputView!
    @IBOutlet weak private var cardNumberInputView: ABInputView!
    @IBOutlet weak private var addCardButton: UIButton!
    @IBOutlet weak private var continueButton: ABButton!
    @IBOutlet weak private var limitView: VisaLimitComponentView!
    @IBOutlet weak private var instructionView: VisaInstructionsComponentView!

    // MARK: - Lifecycle methods
    public override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    // MARK: Bind to viewModel's observable properties
    private func bind(to viewModel: VisaViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)

        viewModel.route.subscribe(onNext: { [weak self] route in
            self?.didRecive(route: route)
        }).disposed(by: disposeBag)
    }

    private func didRecive(action: VisaViewModelOutputAction) {
        switch action {
        case .showView(let type):
            handleShowView(of: type)
        case .enterAmount(let amount):
            let account = 0 // TODO: Nika specify currentcy chosen account index
            viewModel.entered(amount: amount, account: account)
        case .updateAmount(let amount):
            {}() // TODO: Nika update amount input with "amount"
        case .updateAccounts(let accounts):
            {}() // TODO: Nika update account picker view with "accounts"
        case .updateContinue(let isEnabled):
            {}() // TODO: Nika update isUserInteractionEnabled of continue button
        case .updateMin(let min):
            {}() // TODO: Nika update min amount text
        case .updateDisposable(let disposable):
            {}() // TODO: Nika update min disposable text
        case .updateMax(let max):
            {}() // TODO: Nika update max disposable text
        case .show(error: let error):
            {}() // TODO: Nika handle error
        }
    }

    private func handleShowView(of type: VisaViewType) {
        switch type {
        case .accounts:
            {}() // TODO: Nika handle visualization of view with accounts
        case .addAccount:
            {}() // TODO: Nika handle visualization of add account
        }
    }

    private func didRecive(route: VisaViewModelRoute) {
        switch route {
        case .webView(let params):
            navigator.navigate(to: .webView(params: params), animated: true)
        case .addAccount:
            navigator.navigate(to: .addAccount, animated: true)
        }
    }

    // MARK: Setup methods
    private func setup() {
        setBaseBackgorundColor()
        setupKeyboard()
        setupInputViews()
        setupButtons()
    }

    private func setupInputViews() {
    }

    private func setupButtons() {
        addCardButton.setBackgorundColor(to: .tertiaryBg())
        addCardButton.layer.cornerRadius = 4
        addCardButton.setImage(R.image.deposit.addCard(), for: .normal)
        addCardButton.addTarget(self, action: #selector(addCardDidTap), for: .touchUpInside)

        continueButton.layer.cornerRadius = 4
        continueButton.setStyle(to: .primary(state: .disabled, size: .large))
        continueButton.setTitleWithoutAnimation(R.string.localization.visa_continue_button_title.localized(), for: .normal)
        continueButton.addTarget(self, action: #selector(continueButtonDidTap), for: .touchUpInside)
        continueButton.titleEdgeInsets.bottom = 2

        amountInputView.mainTextField.rx.controlEvent([.editingChanged])
            .asObservable().subscribe({ [weak self] _ in
                self?.updateContinueButton()
            }).disposed(by: disposeBag)
    }

    // MARK: Action methods
    @objc private func addCardDidTap() {
        navigator.navigate(to: .addAccount, animated: true)
    }

    @objc private func continueButtonDidTap() {
    }

    @objc private func updateContinueButton() {
        var isEnabled = true
        if !(cardNumberInputView.mainTextField.text?.isEmpty ?? false) && !(amountInputView.mainTextField.text?.isEmpty ?? false) {
            isEnabled = true
        } else {
            isEnabled = false
        }

        continueButton.isUserInteractionEnabled = isEnabled
        continueButton.setStyle(to: .primary(state: isEnabled ? .active : .disabled, size: .large))
    }
}
