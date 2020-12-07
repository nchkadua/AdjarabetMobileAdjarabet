//
//  CardInfoViewController.swift
//  Mobile
//
//  Created by Nika Chkadua on 12/3/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public class CardInfoViewController: ABViewController {
    @Inject(from: .viewModels) public var viewModel: CardInfoViewModel
    public lazy var navigator = CardInfoNavigator(viewController: self)

    // MARK: Outlets
    @IBOutlet private weak var creditCardComponentView: CreditCardComponentView!
    @IBOutlet private weak var cardNumberInputView: ABInputView!
    @IBOutlet private weak var expirationDateInputView: ABInputView!
    @IBOutlet private weak var cvvInputView: ABInputView!
    @IBOutlet private weak var addCardButton: ABButton!

    // MARK: - Lifecycle methods
    public override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        cardNumberInputView.mainTextField.becomeFirstResponder()
    }

    // MARK: Bind to viewModel's observable properties
    private func bind(to viewModel: CardInfoViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)
    }

    private func didRecive(action: CardInfoViewModelOutputAction) {
        switch action {
        case .bindToCreditCardViewModel(let viewModel): bindToCreditCard(viewModel)
        }
    }

    /// CreditCardViewModel
    private func bindToCreditCard(_ creditCardViewModel: CreditCardComponentViewModel) {
        creditCardComponentView.setAndBind(viewModel: creditCardViewModel)
        bind(to: creditCardViewModel)
    }

    private func bind(to viewModel: CreditCardComponentViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)
    }

    private func didRecive(action: CreditCardComponentViewModelOutputAction) {
    }

    // MARK: Setup methods
    private func setup() {
        setBaseBackgorundColor(to: .secondaryBg())
        setupNavigationItems()
        setupKeyboard()
        setupInputViews()
        setupAddCardButton()
    }

    private func setupNavigationItems() {
        setBackBarButtonItemIfNeeded()
        let scanCardButton = makeScanBarButtonItem(width: 220)
        navigationItem.rightBarButtonItem = scanCardButton.barButtonItem
        scanCardButton.button.addTarget(self, action: #selector(openScanner), for: .touchUpInside)
    }

    private func setupInputViews() {
        cardNumberInputView.setupWith(backgroundColor: .querternaryFill(), borderWidth: 0)
        cardNumberInputView.setPlaceholder(text: R.string.localization.card_number_title.localized())
        cardNumberInputView.mainTextField.keyboardType = .numberPad
        cardNumberInputView.maxLength = 16

        expirationDateInputView.setupWith(backgroundColor: .querternaryFill(), borderWidth: 0)
        expirationDateInputView.setPlaceholder(text: R.string.localization.active_till.localized())
        expirationDateInputView.mainTextField.inputView = ABDatePickerView(holder: expirationDateInputView)

        cvvInputView.setupWith(backgroundColor: .querternaryFill(), borderWidth: 0)
        cvvInputView.setPlaceholder(text: R.string.localization.card_cvv.localized())
        cvvInputView.mainTextField.keyboardType = .numberPad
        cvvInputView.maxLength = 3

        handleCardNumberInputViewActions()
        handleExpirationDateInpirViewActions()
        handleCVVInputViewActions()
    }

    // MARK: InputView Actions
    private func handleCardNumberInputViewActions() {
        cardNumberInputView.mainTextField.rx.controlEvent(.editingDidBegin).subscribe(onNext: { _ in
            self.viewModel.focusOn(.cardNumber)
        }).disposed(by: disposeBag)

        cardNumberInputView.mainTextField.rx.controlEvent(.editingDidEnd).subscribe(onNext: { _ in
            self.viewModel.setCardNumber(self.cardNumberInputView.mainTextField.text)
        }).disposed(by: disposeBag)
    }

    private func handleExpirationDateInpirViewActions() {
        expirationDateInputView.mainTextField.rx.controlEvent(.editingDidBegin).subscribe(onNext: { _ in
            self.viewModel.focusOn(.usageDate)
        }).disposed(by: disposeBag)

        expirationDateInputView.mainTextField.rx.controlEvent(.editingDidEnd).subscribe(onNext: { _ in
            let month = self.expirationDateInputView.mainTextField.text?.prefix(2) ?? ""
            let year = self.expirationDateInputView.mainTextField.text?.suffix(2) ?? ""
            self.viewModel.setUsageDate(month: String(month), year: String(year))
        }).disposed(by: disposeBag)
    }

    private func handleCVVInputViewActions() {
        cvvInputView.mainTextField.rx.controlEvent(.editingDidBegin).subscribe(onNext: { _ in
            self.viewModel.focusOn(.CVV)
        }).disposed(by: disposeBag)

        cvvInputView.mainTextField.rx.controlEvent(.editingDidEnd).subscribe(onNext: { _ in
            self.viewModel.setCVV(self.cvvInputView.mainTextField.text)
        }).disposed(by: disposeBag)
    }

    private func setupAddCardButton() {
        addCardButton.setStyle(to: .tertiary(state: .acvite, size: .large))
        addCardButton.setTitleWithoutAnimation(R.string.localization.card_add_button_title.localized(), for: .normal)
        addCardButton.addTarget(self, action: #selector(addCardDidTap), for: .touchUpInside)
    }

    @objc private func addCardDidTap() {
        closeKeyboard()
    }

    // MARK: Action Methods
    @objc private func openScanner() {
        print("Openning Scanner...")
    }
}

extension CardInfoViewController: CommonBarButtonProviding { }
