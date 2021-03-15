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

    @Inject(from: .repositories) private var repo: TBCRegularPaymentsRepository

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

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.cardNumberInputView.mainTextField.becomeFirstResponder()
        }
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
        proceedButton.setStyle(to: .primary(state: .disabled, size: .large))
        proceedButton.setTitleWithoutAnimation(R.string.localization.withdraw_proceed_button_title(), for: .normal)
        proceedButton.addTarget(self, action: #selector(proceedDidTap), for: .touchUpInside)

        amountInputView.mainTextField.rx.controlEvent([.editingChanged])
            .asObservable().subscribe({ [weak self] _ in
                self?.updateProceedButton()
            }).disposed(by: disposeBag)
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
    private func updateProceedButton() {
        var isEnabled = true
        if !(cardNumberInputView.mainTextField.text?.isEmpty ?? false) && !(amountInputView.mainTextField.text?.isEmpty ?? false) {
            isEnabled = true
        } else {
            isEnabled = false
        }

        proceedButton.isUserInteractionEnabled = isEnabled
        proceedButton.setStyle(to: .primary(state: isEnabled ? .active : .disabled, size: .large))
    }

    // MARK: Action methods
    @objc private func proceedDidTap() {
        repo.initWithdraw(params: .init(amount: 10)) { result in
            switch result {
            case .success(let entity): self.withdraw(with: entity.fee ?? 0.0, session: entity.sessionId ?? "")
            case .failure(let error): print("Payment.Withdraw: ", error)
            }
        }
    }

    // Temporary
    private func withdraw(with fee: Double, session: String) {
        print("Payment.Withdraw: ", fee)
        repo.withdraw(params: .init(amount: 10, accountId: 8310929, session: session)) { result in
            switch result {
            case .success(let entity):
                print("Payment.Withdraw: ", entity.message)
                self.showAlert(title: "\(entity.message)")
            case .failure(let error):
                print("Payment.Withdraw: ", error)
                self.showAlert(title: "\(error)")
            }
        }
    }
}
