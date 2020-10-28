//
//  AccountInfoViewController.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/21/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public class AccountInfoViewController: ABViewController {
    // MARK: Properties
    @Inject(from: .viewModels) private var viewModel: AccountInfoViewModel
    public lazy var navigator = AccountInfoNavigator(viewController: self)

    // MARK: Outlets
    @IBOutlet private weak var scrollView: UIScrollView!
    /// ComponentViews
    @IBOutlet private weak var userIdView: AccountInfoComponentView!
    @IBOutlet private weak var personalIdView: AccountInfoComponentView!
    @IBOutlet private weak var statusView: AccountInfoComponentView!
    @IBOutlet private weak var passwordView: AccountInfoComponentView!
    @IBOutlet private weak var nameView: AccountInfoComponentView!
    @IBOutlet private weak var surnameView: AccountInfoComponentView!
    @IBOutlet private weak var birthDateView: AccountInfoComponentView!
    @IBOutlet private weak var genderView: AccountInfoComponentView!
    @IBOutlet private weak var countryView: AccountInfoComponentView!
    @IBOutlet private weak var usernameView: AccountInfoComponentView!
    @IBOutlet private weak var mailView: AccountInfoComponentView!
    @IBOutlet private weak var phoneNumberView: AccountInfoComponentView!
    @IBOutlet private weak var addressView: AccountInfoComponentView!
    @IBOutlet private weak var privateInfoHeaderLabel: UILabel!
    @IBOutlet private weak var contactInfoHeaderLabel: UILabel!
    @IBOutlet private weak var personalInfoHeaderLabel: UILabel!
    /// Buttons
    @IBOutlet private weak var editPasswordButton: UIButton!
    @IBOutlet private weak var editMailButton: UIButton!
    @IBOutlet private weak var editPhoneNumberButton: UIButton!
    @IBOutlet private weak var editAddressButton: UIButton!
    @IBOutlet private weak var statusButton: ABButton!

    // MARK: Overrides
    public override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    // MARK: - Lifecycle methods
    public override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }

    // MARK: Bind to viewModel's observable properties
    private func bind(to viewModel: AccountInfoViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)

        viewModel.route.subscribe(onNext: { [weak self] route in
            self?.didRecive(route: route)
        }).disposed(by: disposeBag)
    }

    private func didRecive(action: AccountInfoViewModelOutputAction) {
        switch action {
        case .setupWithUserInfo(let userInfo): setupViewsWith(userInfo: userInfo)
        case .setupWithUserSession(let userSession): setupViewsWith(userSession: userSession)
        }
    }

    private func didRecive(route: AccountInfoViewModelRoute) {
    }

    // MARK: Setup methods
    private func setup() {
        setBaseBackgorundColor(to: .baseBg300())
        setupNavigationItems()
        setupScrollView()
        setupLabels()
        setupButtons()
    }

    private func setupNavigationItems() {
        setTitle(title: R.string.localization.account_information_title())
        setBackBarButtonItemIfNeeded(width: 44)
    }

    private func setupScrollView() {
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = false
    }

    private func setupLabels() {
        privateInfoHeaderLabel.setFont(to: .h3(fontCase: .lower))
        privateInfoHeaderLabel.setTextColor(to: .systemWhite())
        privateInfoHeaderLabel.text = R.string.localization.account_info_private_info_title()

        contactInfoHeaderLabel.setFont(to: .h3(fontCase: .lower))
        contactInfoHeaderLabel.setTextColor(to: .systemWhite())
        contactInfoHeaderLabel.text = R.string.localization.account_info_contact_info_title()

        personalInfoHeaderLabel.setFont(to: .h3(fontCase: .lower))
        personalInfoHeaderLabel.setTextColor(to: .systemWhite())
        personalInfoHeaderLabel.text = R.string.localization.account_info_personal_info_title()
    }

    private func setupButtons() {
        statusButton.setStyle(to: .secondary(state: .acvite, size: .small))
        statusButton.setTitleColor(to: .systemRed100(), for: .normal)
        statusButton.cornerRadius = 15
        statusButton.setTitleWithoutAnimation(R.string.localization.account_info_status_button_title(), for: .normal)
        statusButton.addTarget(self, action: #selector(statusButtonAction), for: .touchUpInside)

        editPasswordButton.addTarget(self, action: #selector(editPasswordAction), for: .touchUpInside)
        editMailButton.addTarget(self, action: #selector(editMailAction), for: .touchUpInside)
        editPhoneNumberButton.addTarget(self, action: #selector(editPhoneNumberAction), for: .touchUpInside)
        editAddressButton.addTarget(self, action: #selector(editAddressAction), for: .touchUpInside)
    }

    private func setupViewsWith(userInfo: UserInfoServices) {
        personalIdView.set(placeholderText: R.string.localization.account_info_personal_id(), titleText: userInfo.personalID)
        personalIdView.set(placeholderText: R.string.localization.account_info_personal_id(), titleText: userInfo.personalID)

        statusView.set(placeholderText: R.string.localization.account_info_status(), titleText: "Verified")
        statusView.rightImage = R.image.components.profileCell.verified()
        statusView.bringSubviewToFront(statusButton)

        mailView.set(placeholderText: R.string.localization.account_info_mail(), titleText: userInfo.mail)
        mailView.bringSubviewToFront(editMailButton)

        phoneNumberView.set(placeholderText: R.string.localization.account_info_phone_number(), titleText: userInfo.phoneNumber.asPhoneNumber)
        phoneNumberView.bringSubviewToFront(editPhoneNumberButton)

        addressView.set(placeholderText: R.string.localization.account_info_address(), titleText: userInfo.address)
        addressView.bringSubviewToFront(editAddressButton)

        nameView.set(placeholderText: R.string.localization.account_info_name(), titleText: userInfo.name)
        surnameView.set(placeholderText: R.string.localization.account_info_surname(), titleText: userInfo.surname)
        birthDateView.set(placeholderText: R.string.localization.account_info_birth_date(), titleText: userInfo.birthDate)
        genderView.set(placeholderText: R.string.localization.account_info_gender(), titleText: userInfo.gender)
        countryView.set(placeholderText: R.string.localization.account_info_country(), titleText: userInfo.country)
    }

    private func setupViewsWith(userSession: UserSessionServices) {
        usernameView.set(placeholderText: R.string.localization.account_info_username(), titleText: userSession.username ?? "Guest")
        userIdView.set(placeholderText: R.string.localization.account_info_user_id(), titleText: String(userSession.userId ?? 0))
        passwordView.set(placeholderText: R.string.localization.account_info_password(), titleText: String.passwordRepresentation)
        passwordView.bringSubviewToFront(editPasswordButton)
    }

    // MARK: Action methods
    @objc private func statusButtonAction () {
        showAlert(title: "Self Suspend")
    }

    @objc private func editPasswordAction() {
        showAlert(title: "Edit Password")
    }

    @objc private func editMailAction() {
        showAlert(title: "Edit Mail")
    }

    @objc private func editPhoneNumberAction() {
        showAlert(title: "Edit Phone Number")
    }

    @objc private func editAddressAction() {
        showAlert(title: "Edit Address")
    }
}

extension AccountInfoViewController: CommonBarButtonProviding { }
