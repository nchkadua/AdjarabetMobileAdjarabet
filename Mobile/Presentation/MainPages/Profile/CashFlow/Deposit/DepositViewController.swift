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

    // MARK: - Lifecycle methods
    public override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        bind(to: viewModel)
        viewModel.viewDidLoad()
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
        cardNumberInputView.setupPickerView(withItems: payment.cards)
    }

    // MARK: Setup methods
    private func setup() {
        setBaseBackgorundColor(to: .systemGray100())
        setupKeyboard()
        setupButtons()
        setupInputViews()
    }

    private func setupButtons() {
        addCardButton.setBackgorundColor(to: .fill50())
        addCardButton.layer.cornerRadius = 4
        addCardButton.setImage(R.image.deposit.addCard(), for: .normal)

        proceedButton.setStyle(to: .primary(state: .acvite, size: .large))
        proceedButton.setTitleWithoutAnimation(R.string.localization.deposit_proceed_button_title(), for: .normal)
        proceedButton.addTarget(self, action: #selector(proceedDidTap), for: .touchUpInside)
    }

    private func setupInputViews() {
        paymentMethodInputView.setupWith(backgroundColor: .fill50(), borderWidth: 0)
        paymentMethodInputView.setPlaceholder(text: R.string.localization.deposit_payment_method_title())

        amountInputView.setupWith(backgroundColor: .fill50(), borderWidth: 0)
        amountInputView.mainTextField.keyboardType = .decimalPad
        amountInputView.setPlaceholder(text: R.string.localization.deposit_amount_title())

        cardNumberInputView.setupWith(backgroundColor: .fill50(), borderWidth: 0)
        cardNumberInputView.setPlaceholder(text: R.string.localization.deposit_card_title())
    }

    // MARK: Action methods
    @objc private func proceedDidTap() {
    }
}
