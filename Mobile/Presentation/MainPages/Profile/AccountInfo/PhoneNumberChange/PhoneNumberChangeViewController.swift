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
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var phonePrefixInputView: ABInputView!
    @IBOutlet private weak var phoneNumberInputView: ABInputView!
    @IBOutlet private weak var approveButton: ABButton!

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
        setupLabel()
    }

    private func setupNavigationItems() {
        setTitle(title: R.string.localization.phone_number_change_title.localized())
    }

    private func setupInputView() {
        phonePrefixInputView.setupWith(backgroundColor: .querternaryFill(), borderWidth: 0)
        phonePrefixInputView.setPlaceholder(text: R.string.localization.phone_prefix.localized())

        let titles = Country.allCases
            .map { $0.description }
            .sorted { $0.alpha3Code < $1.alpha3Code }
            .map { $0.title }

        phonePrefixInputView.setupPickerView(withItems: titles)

        phoneNumberInputView.setupWith(backgroundColor: .querternaryFill(), borderWidth: 0)
        phoneNumberInputView.setPlaceholder(text: R.string.localization.new_phone_number.localized())
        phoneNumberInputView.mainTextField.keyboardType = .numberPad
    }

    private func setDefaultPrexif(_ prefix: String) {
         phonePrefixInputView.setDefaultValue(Country(localizableIdentifier: prefix)?.description.title ?? "")
//        phonePrefixInputView.setDefaultValue(Country.allCases.first?.description.title ?? "")
    }

    private func setupApproveButton() {
        approveButton.setStyle(to: .primary(state: .active, size: .large))
        approveButton.setTitleWithoutAnimation(R.string.localization.approve_address_button_title.localized(), for: .normal)
        approveButton.addTarget(self, action: #selector(approveDidTap), for: .touchUpInside)
    }

    @objc private func approveDidTap() {
        closeKeyboard()
    }

    private func setupLabel() {
        subtitleLabel.setFont(to: .caption2(fontCase: .lower))
        subtitleLabel.setTextColor(to: .primaryText())
        subtitleLabel.text = R.string.localization.phone_number_subtitle.localized()
    }
}
