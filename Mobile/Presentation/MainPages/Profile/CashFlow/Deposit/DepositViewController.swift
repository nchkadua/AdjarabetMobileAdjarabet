//
//  DepositViewController.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/28/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public class DepositViewController: ABViewController {
    @Inject(from: .viewModels) private var viewModel: DepositViewModel
    public lazy var navigator = DepositNavigator(viewController: self)

    // MARK: Outlets
    @IBOutlet private weak var labelComponentView: LabelComponentView!
    @IBOutlet private weak var paymentMethodInputView: ABInputView!
    @IBOutlet private weak var amountInputView: ABInputView!
    @IBOutlet private weak var cardNumberInputView: ABInputView!
    @IBOutlet private weak var addCardButton: UIButton!
    @IBOutlet private weak var proceedButton: ABButton!

    var tBCRegularPaymentsRepository = TBCRegularPaymentsRepository()

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

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.paymentMethodInputView.mainTextField.becomeFirstResponder()
        }
    }

    // MARK: Bind to viewModel's observable properties
    private func bind(to viewModel: DepositViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)

        viewModel.route.subscribe(onNext: { [weak self] route in
            self?.didRecive(route: route)
        }).disposed(by: disposeBag)
    }

    private func didRecive(action: DepositViewModelOutputAction) {
        switch action {
        case .setupWithLabel(let label): setupLabel(with: label)
        case .setupPaymentMethods(let payment): setupPaymentMethods(with: payment)
        }
    }

    private func didRecive(route: DepositViewModelRoute) {
    }

    private func setupLabel(with label: LabelComponentViewModel) {
        labelComponentView.set(label: label)
    }

    private func setupPaymentMethods(with payment: Payment) {
        paymentMethodInputView.setupPickerView(withItems: payment.paymentMethods)
        paymentMethodInputView.setDefaultValue(payment.paymentMethods.first ?? "")

        cardNumberInputView.setupPickerView(withItems: payment.cards)
        cardNumberInputView.setDefaultValue(payment.cards.first ?? "")
    }

    // MARK: Setup methods
    private func setup() {
        setBaseBackgorundColor(to: .secondaryBg())
        setupKeyboard()
        setupButtons()
        setupInputViews()
    }

    private func setupButtons() {
        addCardButton.setBackgorundColor(to: .querternaryFill())
        addCardButton.layer.cornerRadius = 8
        addCardButton.setImage(R.image.deposit.addCard(), for: .normal)
        addCardButton.addTarget(self, action: #selector(addCardDidTap), for: .touchUpInside)

        proceedButton.setStyle(to: .primary(state: .disabled, size: .large))
        proceedButton.setTitleWithoutAnimation(R.string.localization.deposit_proceed_button_title(), for: .normal)
        proceedButton.addTarget(self, action: #selector(proceedDidTap), for: .touchUpInside)

        amountInputView.mainTextField.rx.controlEvent([.editingChanged])
            .asObservable().subscribe({ [weak self] _ in
                self?.updateProceedButton()
            }).disposed(by: disposeBag)
    }

    private func setupInputViews() {
        paymentMethodInputView.setupWith(backgroundColor: .querternaryFill(), borderWidth: 0)
        paymentMethodInputView.setPlaceholder(text: R.string.localization.deposit_payment_method_title())

        amountInputView.setupWith(backgroundColor: .querternaryFill(), borderWidth: 0)
        amountInputView.mainTextField.keyboardType = .decimalPad
        amountInputView.setPlaceholder(text: R.string.localization.deposit_amount_title())
        amountInputView.formatter = AmountFormatter()

        cardNumberInputView.setupWith(backgroundColor: .querternaryFill(), borderWidth: 0)
        cardNumberInputView.setPlaceholder(text: R.string.localization.deposit_card_title())
    }

    // MARK: Configuration
    private func updateProceedButton() {
        var isEnabled = true
        if !(cardNumberInputView.mainTextField.text?.isEmpty ?? false) && !(amountInputView.mainTextField.text?.isEmpty ?? false) &&
            !(paymentMethodInputView.mainTextField.text?.isEmpty ?? false) {
            isEnabled = true
        } else {
            isEnabled = false
        }

        proceedButton.isUserInteractionEnabled = isEnabled
        proceedButton.setStyle(to: .primary(state: isEnabled ? .active : .disabled, size: .large))
    }

    // MARK: Action methods
    @objc private func addCardDidTap() {
        navigator.navigate(to: .addCard, animated: true)
    }

    @objc private func proceedDidTap() {
        tBCRegularPaymentsRepository.deposit { result in
            switch result {
            case .success(let tbcRegularPaymentsEntity): print("asdasd ", tbcRegularPaymentsEntity)
            case .failure(let error): print("asdasd ", error)
            }
        }
    }
}
