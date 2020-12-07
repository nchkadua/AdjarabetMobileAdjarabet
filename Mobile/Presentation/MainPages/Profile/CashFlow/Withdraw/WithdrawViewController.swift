//
//  WithdrawViewController.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/28/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public class WithdrawViewController: ABViewController {
    @Inject(from: .viewModels) private var viewModel: WithdrawViewModel
    public lazy var navigator = WithdrawNavigator(viewController: self)

    // MARK: Outlets
    @IBOutlet private weak var titleLabelComponentView: LabelComponentView!
    @IBOutlet private weak var cardNumberInputView: ABInputView!
    @IBOutlet private weak var amountInputView: ABInputView!
    @IBOutlet private weak var commissionLabelComponentView: LabelComponentView!
    @IBOutlet private weak var totalAmountLabelComponentView: LabelComponentView!
    @IBOutlet private weak var proceedButton: ABButton!

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
    private func bind(to viewModel: WithdrawViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)

        viewModel.route.subscribe(onNext: { [weak self] route in
            self?.didRecive(route: route)
        }).disposed(by: disposeBag)
    }

    private func didRecive(action: WithdrawViewModelOutputAction) {
        switch action {
        case .setupWithLabel(let label): setupLabel(with: label)
        case .setupPaymentMethods(let payment): setupPaymentMethods(with: payment)
        case .updateCommission(let commission): commissionLabelComponentView.change(value: "\(commission) ₾")
        case .updateTotalAmount(let totalAmount): totalAmountLabelComponentView.change(value: "\(totalAmount) ₾")
        }
    }

    private func didRecive(route: WithdrawViewModelRoute) {
    }

    private func setupLabel(with label: LabelComponentViewModel) {
        titleLabelComponentView.set(label: label)
    }

    private func setupPaymentMethods(with payment: Payment) {
        cardNumberInputView.setupPickerView(withItems: payment.cards)
        cardNumberInputView.setDefaultValue(payment.cards.first ?? "")
    }

    // MARK: Setup methods
    private func setup() {
        setBaseBackgorundColor(to: .secondaryBg())
        setupKeyboard()
        setupLabels()
        setupButtons()
        setupInputViews()
    }

    private func setupLabels() {
        commissionLabelComponentView.setBackgorundColor(to: .tertiaryBg())
        totalAmountLabelComponentView.setBackgorundColor(to: .tertiaryBg())

        commissionLabelComponentView.valueLabelComponent.setFont(to: .subHeadline(fontCase: .upper))
        totalAmountLabelComponentView.valueLabelComponent.setFont(to: .subHeadline(fontCase: .upper))

        commissionLabelComponentView.set(label: LabelComponentViewModel(title: R.string.localization.withdraw_commission_title(), value: "0.0 ₾"))
        totalAmountLabelComponentView.set(label: LabelComponentViewModel(title: R.string.localization.withdraw_total_amount_title(), value: "0.0 ₾"))

        commissionLabelComponentView.roundCorners([.topLeft, .topRight], radius: 8)
        totalAmountLabelComponentView.roundCorners([.bottomLeft, .bottomRight], radius: 8)
    }

    private func setupButtons() {
        proceedButton.setStyle(to: .tertiary(state: .disabled, size: .large))
        proceedButton.setTitleWithoutAnimation(R.string.localization.withdraw_proceed_button_title(), for: .normal)
        proceedButton.addTarget(self, action: #selector(proceedDidTap), for: .touchUpInside)
        updateProceedButton(isEnabled: false)

        Observable.combineLatest([cardNumberInputView.rx.text.orEmpty, amountInputView.rx.text.orEmpty])
            .map { $0.map { !$0.isEmpty } }
            .map { $0.allSatisfy { $0 == true } }
            .subscribe(onNext: { [weak self] isValid in
                self?.updateProceedButton(isEnabled: isValid)
            })
            .disposed(by: disposeBag)
    }

    private func setupInputViews() {
        amountInputView.setupWith(backgroundColor: .querternaryFill(), borderWidth: 0)
        amountInputView.mainTextField.keyboardType = .decimalPad
        amountInputView.setPlaceholder(text: R.string.localization.withdraw_amount_title())
        amountInputView.formatter = AmountFormatter()

        cardNumberInputView.setupWith(backgroundColor: .querternaryFill(), borderWidth: 0)
        cardNumberInputView.setPlaceholder(text: R.string.localization.withdraw_card_title())

        amountInputView.mainTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }

    @objc private func textFieldDidChange(_ textField: UITextField) {
        viewModel.textDidChange(to: textField.text)
    }

    // MARK: Configuration
    private func updateProceedButton(isEnabled: Bool) {
        proceedButton.isUserInteractionEnabled = isEnabled
        proceedButton.setStyle(to: .tertiary(state: isEnabled ? .acvite : .disabled, size: .large))
    }

    // MARK: Action methods
    @objc private func proceedDidTap() {
    }
}
