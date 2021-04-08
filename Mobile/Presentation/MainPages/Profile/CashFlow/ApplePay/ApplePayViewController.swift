//
//  ApplePayViewController.swift
//  Mobile
//
//  Created by Nika Chkadua on 4/7/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public class ApplePayViewController: ABViewController {
    @Inject(from: .viewModels) public var viewModel: ApplePayViewModel
    public lazy var navigator = ApplePayNavigator(viewController: self)

    @IBOutlet weak private var amountInputView: ABInputView!
    @IBOutlet weak private var applePayButton: ApplePayButton!
    @IBOutlet weak private var limitsComponentView: VisaLimitComponentView!

    private var amount: String { amountInputView.text ?? "" }

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
    private func bind(to viewModel: ApplePayViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)
    }

    private func didRecive(action: ApplePayViewModelOutputAction) {
        switch action {
        case .updateMin(let min): self.limitsComponentView.updateMin(min)
        case .updateDisposable(let disposable): self.limitsComponentView.updateDaily(disposable)
        case .updateMax(let max): self.limitsComponentView.updateMax(max)
        case .updateAmount(let amount): amountInputView.set(text: amount)
        case .updateContinue(let isEnabled): updateApayButton(isEnabled)
        case .show(error: let error): showAlert(title: error)
        case .bindToGridViewModel(viewModel: let viewModel): bindToGrid(viewModel)
        }
    }

    // MARK: Setup methods
    private func setup() {
        setBaseBackgorundColor()
        setupKeyboard()
        setupInputView()
        setupButton()
        setupSuggestedAmountsGrid()
    }

    private func setupInputView() {
        amountInputView.setupWith(backgroundColor: .tertiaryBg(), borderWidth: 0)
        amountInputView.mainTextField.keyboardType = .decimalPad
        amountInputView.setPlaceholder(text: R.string.localization.visa_amount_title.localized())

        amountInputView.mainTextField.addTarget(self, action: #selector(amountEditingDidBegin), for: .editingDidBegin)
        amountInputView.mainTextField.addTarget(self, action: #selector(amountEditingDidEnd), for: .editingDidEnd)
    }

    private func setupButton() {
        applePayButton.addTarget(self, action: #selector(applePayButtonAction), for: .touchUpInside)
        updateApayButton(false)
    }

    private func setupSuggestedAmountsGrid() {
        suggestedAmountGridComponentView = SuggestedAmountGridComponentView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 90))
        amountInputView.mainTextField.inputAccessoryView = suggestedAmountGridComponentView
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
        case .didClickClear:
            amountInputView.set(text: "")
            updateApayButton(false)
        case .didClickDone: view.endEditing(false)
        default:
            break
        }
    }

    // MARK: Action methods
    @objc private func amountEditingDidBegin() {
        amountInputView.set(text: "")
        updateApayButton(false)
    }

    @objc private func amountEditingDidEnd() {
        viewModel.entered(amount: amount)
    }

    private func updateApayButton(_ isEnabled: Bool) {
        applePayButton.isEnabled = isEnabled
    }

    private func updateAmountInputeView(_ amountViewModel: SuggestedAmountComponentViewModel) {
        amountInputView.set(text: String(amountViewModel.params.amount))
        view.endEditing(false)
    }

    @objc private func applePayButtonAction() {
    }
}
