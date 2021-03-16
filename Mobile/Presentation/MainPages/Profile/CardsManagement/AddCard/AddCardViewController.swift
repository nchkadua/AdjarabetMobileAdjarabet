//
//  AddCardViewController.swift
//  Mobile
//
//  Created by Nika Chkadua on 12/3/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public class AddCardViewController: ABViewController {
    @Inject(from: .viewModels) public var viewModel: AddCardViewModel
    public lazy var navigator = AddCardNavigator(viewController: self)

    // MARK: Outlets
    @IBOutlet private weak var minAmountComponentView: MinAmountComponentView!
    @IBOutlet private weak var amountInputView: ABInputView!
    @IBOutlet private weak var agreementComponentView: AgreementComponentView!
    @IBOutlet private weak var continueButton: ABButton!

    //
    private let minimumAmount = 1.0
    private var enteredAmount = 0.0
    private var hasAgreedToTerms = false

    // MARK: - Lifecycle methods
    public override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        amountInputView.mainTextField.becomeFirstResponder()
    }

    // MARK: Bind to viewModel's observable properties
    private func bind(to viewModel: AddCardViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)
        viewModel.route.subscribe(onNext: { [weak self] route in
            self?.didRecive(route: route)
        }).disposed(by: disposeBag)
    }

    private func didRecive(action: AddCardViewModelOutputAction) {
        switch action {
        case .bindToMinAmountComponentViewModel(let viewModel): bindToMinAmount(viewModel)
        case .bindToAgreementComponentViewModel(let viewModel): bindAgreement(viewModel)
        }
    }

    private func didRecive(route: AddCardViewModelRoute) {
        switch route {
        case .webView(let params):
            navigator.navigate(to: .webView(params: params), animated: true)
        }
    }

    /// MinAmountViewModel
    private func bindToMinAmount(_ minAmountViewModel: MinAmountComponentViewModel) {
        minAmountComponentView.setAndBind(viewModel: minAmountViewModel)
        bind(to: minAmountViewModel)
    }

    private func bind(to viewModel: MinAmountComponentViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)
    }

    private func didRecive(action: MinAmountComponentViewModelOutputAction) {
        switch action {
        case .didClickMinimumAmountButton(let minAmount): updateAmountInputView(with: minAmount)
        }
    }

    /// AgreementViewModel
    private func bindAgreement(_ agreementViewModel: AgreementComponentViewModel) {
        agreementComponentView.setAndBind(viewModel: agreementViewModel)
        bind(to: agreementViewModel)
    }

    private func bind(to viewModel: AgreementComponentViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)
    }

    private func didRecive(action: AgreementComponentViewModelOutputAction) {
        switch action {
        case .agreementUpdated(let agreed): updateAgreementStatus(withAgreementStatus: agreed)
        }
    }

    // MARK: Setup methods
    private func setup() {
        setBaseBackgorundColor(to: .secondaryBg())
        setupNavigationItems()
        setupKeyboard()
        setupAmountInputView()
        setupContinueButton()
    }

    private func setupNavigationItems() {
        setTitle(title: R.string.localization.add_card_title.localized())
    }

    private func setupAmountInputView() {
        amountInputView.setupWith(backgroundColor: .querternaryFill(), borderWidth: 0)
        amountInputView.mainTextField.keyboardType = .decimalPad
        amountInputView.setPlaceholder(text: R.string.localization.deposit_amount_title())
        amountInputView.formatter = AmountFormatter()

        amountInputView.mainTextField.rx.controlEvent([.editingChanged]).subscribe(onNext: { [weak self] in
            self?.updateAmountInputViewImage()
            self?.updateContinueButton()
        }).disposed(by: disposeBag)
    }

    private func setupContinueButton() {
        continueButton.setStyle(to: .primary(state: .disabled, size: .large))
        continueButton.setTitleWithoutAnimation(R.string.localization.add_card_continue_button_title.localized(), for: .normal)
        continueButton.addTarget(self, action: #selector(continueButtonDidTap), for: .touchUpInside)
    }

    @objc private func continueButtonDidTap() {
        closeKeyboard()
        viewModel.continueTapped(with: enteredAmount, hasAgreedToTerms: hasAgreedToTerms)
    }

    // MARK: Action Methods
    private func updateAmountInputView(with minAmount: Double) {
        let text = NumberFormatter().string(from: NSNumber(value: minAmount))
        amountInputView.setTextAndConfigure(text: text, animated: true)
        amountInputView.setRightButtonImage(R.image.cardManagement.checkmark() ?? UIImage(), for: .normal)
        amountInputView.mainTextField.resignFirstResponder()
        updateContinueButton()
    }

    private func updateAgreementStatus(withAgreementStatus agreementStatus: Bool) {
        hasAgreedToTerms = agreementStatus
        updateContinueButton()
    }

    private func updateAmountInputViewImage() {
        if let amount = amount2Double(),
            amount >= minimumAmount {
            amountInputView.setRightButtonImage(R.image.cardManagement.checkmark() ?? UIImage(), for: .normal)
        } else {
            amountInputView.setRightButtonImage(UIImage(), for: .normal)
        }
    }

    private func updateContinueButton() {
        enteredAmount = amount2Double() ?? 0.0
        if enteredAmount >= minimumAmount {
            continueButton.setStyle(to: .primary(state: .active, size: .large))
            continueButton.isUserInteractionEnabled = true
        } else {
            continueButton.setStyle(to: .primary(state: .disabled, size: .large))
            continueButton.isUserInteractionEnabled = false
        }
    }

    // MARK: Helpers
    // FIXME: Common with deposit
    private func amount2Double() -> Double? {
        guard let text   = amountInputView.mainTextField.text,
              let number = NumberFormatter().number(from: text),
              let result = Double(exactly: number)
        else {
            return nil
        }
        return result
    }
}
