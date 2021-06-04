//
//  PhoneNumberChangeViewController.swift
//  Mobile
//
//  Created by Nika Chkadua on 11/30/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public class PhoneNumberChangeViewController: ABViewController {
    @Inject(from: .viewModels) public var viewModel: PhoneNumberChangeViewModel
    public lazy var navigator = PhoneNumberChangeNavigator(viewController: self)

    // MARK: Outlets
    @IBOutlet private weak var phonePrefixInputView: ABInputView!
    @IBOutlet private weak var phoneNumberInputView: ABInputView!
    @IBOutlet private weak var approveButton: ABButton!

    @IBOutlet private weak var verticalSeparator: UIView!
    @IBOutlet private weak var horizontalSeparator: UIView!

    // MARK: - Lifecycle methods
    public override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        phoneNumberInputView.mainTextField.becomeFirstResponder()
    }

    // MARK: Bind to viewModel's observable properties
    private func bind(to viewModel: PhoneNumberChangeViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)
    }

    private func didRecive(action: PhoneNumberChangeViewModelOutputAction) {
        switch action {
        case .selectLocalePhonePrefix(let localePhonePrefix): setDefaultPrexif(localePhonePrefix)
        }
    }

    // MARK: Setup methods
    private func setup() {
        setBaseBackgorundColor(to: .secondaryBg())
        setupNavigationItems()
        setupKeyboard()
        setupInputView()
        setupApproveButton()
        setupSeparators()
    }

    private func setupNavigationItems() {
        setTitle(title: R.string.localization.phone_number_change_title.localized().uppercased())

        let backButtonGroup = makeRoundedBackButtonItem()
        navigationItem.leftBarButtonItem = backButtonGroup.barButtonItem
        backButtonGroup.button.addTarget(self, action: #selector(dismissViewController), for: .touchUpInside)
    }

    @objc private func dismissViewController() {
        dismiss(animated: true, completion: nil)
    }

    private func setupInputView() {
        phonePrefixInputView.setupWith(backgroundColor: .querternaryFill(), borderWidth: 0)
        phonePrefixInputView.setPlaceholder(text: R.string.localization.phone_prefix.localized())
        phonePrefixInputView.setupWith(backgroundColor: .secondaryBg(), borderWidth: 0.0)

        let titles = Country.allCases
            .map { $0.description }
            .sorted { $0.alpha3Code < $1.alpha3Code }
            .map { $0.title }

        phonePrefixInputView.setupPickerView(withItems: titles)

        phoneNumberInputView.setupWith(backgroundColor: .querternaryFill(), borderWidth: 0)
        phoneNumberInputView.setupWith(backgroundColor: .secondaryBg(), borderWidth: 0.0)
        phoneNumberInputView.setPlaceholder(text: R.string.localization.new_phone_number.localized())
        phoneNumberInputView.mainTextField.keyboardType = .numberPad

        Observable.combineLatest([phoneNumberInputView.rx.text.orEmpty])
            .map { $0.map { !$0.isEmpty } }
            .map { $0.allSatisfy { $0 == true } }
            .subscribe(onNext: { [weak self] isValid in
                self?.updateApproveButton(isEnabled: isValid)
            })
            .disposed(by: disposeBag)
    }

    private func setDefaultPrexif(_ prefix: String) {
         phonePrefixInputView.setDefaultValue(Country(localizableIdentifier: prefix)?.description.title ?? "")
//        phonePrefixInputView.setDefaultValue(Country.allCases.first?.description.title ?? "")
    }

    private func setupApproveButton() {
        approveButton.setStyle(to: .primary(state: .disabled, size: .large))
        approveButton.setTitleWithoutAnimation(R.string.localization.approve_address_button_title.localized(), for: .normal)
        approveButton.addTarget(self, action: #selector(approveDidTap), for: .touchUpInside)
    }

    private func setupSeparators() {
        verticalSeparator.setBackgorundColor(to: .nonOpaque())
        horizontalSeparator.setBackgorundColor(to: .systemGrey5())
    }

    @objc private func approveDidTap() {
        closeKeyboard()
    }

    // MARK: Configuration
    private func updateApproveButton(isEnabled: Bool) {
        approveButton.isUserInteractionEnabled = isEnabled
        approveButton.setStyle(to: .primary(state: isEnabled ? .active : .disabled, size: .large))
    }
}

extension PhoneNumberChangeViewController: CommonBarButtonProviding { }
