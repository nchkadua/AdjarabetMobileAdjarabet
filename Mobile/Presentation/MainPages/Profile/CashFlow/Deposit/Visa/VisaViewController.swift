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

    private var amount: String { amountInputView.text ?? "" }
    private var account: Int { cardNumberInputView.pickerView.selectedRow(inComponent: 0) }

    private var suggestedAmountGridComponentView: SuggestedAmountGridComponentView?

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
        case .showView(let type): handleShowView(of: type)
        case .updateAmount(let amount): amountInputView.set(text: amount)
        case .updateAccounts(let accounts): setupPaymentCards(with: accounts)
        case .updateContinue(let isEnabled): updateContinueButton(isEnabled)
        case .updateMin(let min): self.limitView.updateMin(min)
        case .updateDisposable(let disposable): self.limitView.updateDaily(disposable)
        case .updateMax(let max): self.limitView.updateMax(max)
        case .show(error: let error): showAlert(title: error)
        case .bindToGridViewModel(let viewModel): bindToGrid(viewModel)
        }
    }

    /// SuggestedAmount Grid
    private func bindToGrid(_ viewModel: SuggestedAmountGridComponentViewModel) {
        suggestedAmountGridComponentView?.setAndBind(viewModel: viewModel)
        bind(to: viewModel)
    }

    private func bind(to viewModel: SuggestedAmountGridComponentViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)
    }

    private func didRecive(action: SuggestedAmountGridComponentViewModelOutputAction) {
        switch action {
        case .didSelectSuggestedAmount(let viewModel, _): updateAmountInputeView(viewModel)
        default:
            break
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
        }
    }

    // MARK: Setup methods
    private func setup() {
        setBaseBackgorundColor()
        setupKeyboard()
        setupInputViews()
        setupButtons()
        setupSuggestedAmountsGrid()
    }

    private func setupInputViews() {
        amountInputView.setupWith(backgroundColor: .tertiaryBg(), borderWidth: 0)
        amountInputView.mainTextField.keyboardType = .decimalPad
        amountInputView.setPlaceholder(text: R.string.localization.visa_amount_title.localized())

        cardNumberInputView.setupWith(backgroundColor: .tertiaryBg(), borderWidth: 0)
        cardNumberInputView.setPlaceholder(text: R.string.localization.visa_card_title.localized())
        cardNumberInputView.delegate = self
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

        amountInputView.mainTextField.addTarget(self, action: #selector(amountEditingDidBegin), for: .editingDidBegin)
        amountInputView.mainTextField.addTarget(self, action: #selector(amountEditingDidEnd), for: .editingDidEnd)
    }

    @objc private func amountEditingDidBegin() {
        amountInputView.set(text: "")
    }

    @objc private func amountEditingDidEnd() {
        viewModel.entered(amount: amount)
    }

    private func setupSuggestedAmountsGrid() {
        suggestedAmountGridComponentView = SuggestedAmountGridComponentView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 60))
        amountInputView.mainTextField.inputAccessoryView = suggestedAmountGridComponentView
    }

    // MARK: Action methods
    @objc private func addCardDidTap() {
        navigator.navigate(to: .addAccount, animated: true)
    }

    @objc private func continueButtonDidTap() {
        viewModel.continued(amount: amount, account: account)
    }

    @objc private func updateContinueButton(_ isEnabled: Bool = true) {
        continueButton.isUserInteractionEnabled = isEnabled
        continueButton.setStyle(to: .primary(state: isEnabled ? .active : .disabled, size: .large))
    }

    private func setupPaymentCards(with accounts: [String]) {
        cardNumberInputView.setupPickerView(withItems: accounts)
        cardNumberInputView.setDefaultValue(accounts.first ?? "")
    }

    private func updateAmountInputeView(_ amountViewModel: SuggestedAmountComponentViewModel) {
        viewModel.entered(amount: String(amountViewModel.params.amount))
    }
}

extension VisaViewController: ABInputViewDelegate {
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel.selected(account: account, amount: amount)
    }
}
