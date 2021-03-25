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
    private lazy var navigator = WithdrawNavigator(viewController: self)

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

    /*
     case .setupWithLabel(let label): setupLabel(with: label)
     case .updateTotalAmount(let totalAmount): totalAmountLabelComponentView.change(value: "\(totalAmount) ₾")
     case .updateSumWith(let fee): commissionLabelComponentView.change(value: "\(fee) ₾")
     case .showAlert(let message): showAlert(title: message)
     */
    private func didRecive(action: WithdrawViewModelOutputAction) {
        switch action {
        case .showView(let type):
            {}() // TODO: Giorgi
        case .updateAmount(let amount):
            amountInputView.set(text: amount)
        case .updateAccounts(let accounts):
            {}()
        case .updateFee(let fee):
            commissionLabelComponentView.change(value: fee)
        case .updateSum(let sum):
            totalAmountLabelComponentView.change(value: sum)
        case .updateContinue(let isEnabled):
            proceedButton.isUserInteractionEnabled = isEnabled
            proceedButton.setStyle(to: .primary(state: isEnabled ? .active : .disabled, size: .large))
        case .updateMin(let min):
            {}() // TODO: Giorgi
        case .updateDisposable(let disposable):
            {}() // TODO: Giorgi
        case .updateMax(let max):
            {}() // TODO: Giorgi
        case .show(let error):
            showAlert(title: error)
        }
    }

    private func didRecive(route: WithdrawViewModelRoute) {
        switch route {
        case .addAccount:
            navigator.navigate(to: .addAccount)
        }
    }

    private func setupLabel(with label: LabelComponentViewModel) {
        titleLabelComponentView.set(label: label)
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
        // FIXME: Bounce time
        //viewModel.handleTextDidChange(amount: amount2Double() ?? 0.0)
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
        //viewModel.proceedTapped(amount: amount2Double() ?? 0.0)
    }
}
