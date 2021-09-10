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
    /// Containers
    @IBOutlet private weak var privateInfoHeaderSV: UIStackView!
    @IBOutlet private weak var privateInfoSV: UIStackView!
    @IBOutlet private weak var contactInfoHeaderSV: UIStackView!
    @IBOutlet private weak var contactInfoSV: UIStackView!
    @IBOutlet private weak var personalInfoHeaderSV: UIStackView!
    @IBOutlet private weak var personalInfoSV: UIStackView!
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
    @IBOutlet private weak var closeAccountView: CloseAccountButtonComponentView!
    @IBOutlet private weak var communicationLanguageComponent: CommunicationLanguageComponentView!

    // MARK: Overrides
    public override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    // MARK: - Lifecycle methods
    public override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        bind(to: viewModel)
        errorThrowing = viewModel
        viewModel.viewDidLoad()
    }

    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupContainers()
    }

    // MARK: Bind to viewModel's observable properties
    private func bind(to viewModel: AccountInfoViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)

        viewModel.route.subscribe(onNext: { [weak self] route in
            self?.didReceive(route: route)
        }).disposed(by: disposeBag)
    }

    private func didRecive(action: AccountInfoViewModelOutputAction) {
        switch action {
        case .setupWithAccountInfoModel(let accountInfoModel):
            setupViewsWith(accountInfoModel: accountInfoModel)
        case .setAndBindCommunicationLanguage(let viewModel):
            communicationLanguageComponent.setAndBind(viewModel: viewModel)
        case .setPersonalID(let id): personalIdView.set(titleText: id)
        case .setAddress(let address): addressView.set(titleText: address)
        case .isLoading(let loading):
            scrollView.isHidden = loading
            loading ? startLoading() : stopLoading()
        }
    }

    private func didReceive(route: AccountInfoViewModelRoute) {
        switch route {
        case .otp(let params):
            navigator.navigate(to: .otp(params: params), animated: true)
        case .addressChange(let params):
            navigator.navigate(to: .addressChange(params: params), animated: true)
        }
    }

    // MARK: Setup methods
    private func setup() {
        setBaseBackgroundColor(to: .secondaryBg())
        setupNavigationItems()
        setupKeyboard()
        setupScrollView()
        setupLabels()
        setTargets()
    }

    private func setupNavigationItems() {
        setTitle(title: R.string.localization.account_information_title.localized())
        navigationItem.titleView?.accessibilityIdentifier = "AccountInfoViewController.title"

        setBackBarButtonItemIfNeeded()
    }

    private func setupScrollView() {
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = false
    }

    private func setupContainers() {
        privateInfoHeaderSV.setBackgorundColor(to: .secondaryBg())
        privateInfoSV.setBackgorundColor(to: .tertiaryBg())
        privateInfoSV.roundCorners(radius: 10)

        contactInfoHeaderSV.setBackgorundColor(to: .secondaryBg())
        contactInfoSV.setBackgorundColor(to: .tertiaryBg())
        contactInfoSV.roundCorners(radius: 10)

        personalInfoHeaderSV.setBackgorundColor(to: .secondaryBg())
        personalInfoSV.setBackgorundColor(to: .tertiaryBg())
        personalInfoSV.roundCorners(radius: 10)
    }

    private func setupLabels() {
        privateInfoHeaderLabel.setFont(to: .subHeadline(fontCase: .lower))
        privateInfoHeaderLabel.setTextColor(to: .primaryText())
        privateInfoHeaderLabel.text = R.string.localization.account_info_private_info_title()

        contactInfoHeaderLabel.setFont(to: .subHeadline(fontCase: .lower))
        contactInfoHeaderLabel.setTextColor(to: .primaryText())
        contactInfoHeaderLabel.text = R.string.localization.account_info_contact_info_title()

        personalInfoHeaderLabel.setFont(to: .subHeadline(fontCase: .lower))
        personalInfoHeaderLabel.setTextColor(to: .primaryText())
        personalInfoHeaderLabel.text = R.string.localization.account_info_personal_info_title()
    }

    private func setTargets() {
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(selfSuspendButtonAction))
        statusView.addGestureRecognizer(tap1)

        let tap2 = UITapGestureRecognizer(target: self, action: #selector(editPasswordAction))
        passwordView.addGestureRecognizer(tap2)

        let tap3 = UITapGestureRecognizer(target: self, action: #selector(editMailAction))
        mailView.addGestureRecognizer(tap3)

        let tap4 = UITapGestureRecognizer(target: self, action: #selector(editPhoneNumberAction))
        phoneNumberView.addGestureRecognizer(tap4)

        let tap5 = UITapGestureRecognizer(target: self, action: #selector(editAddressAction))
        addressView.addGestureRecognizer(tap5)

        let tap6 = UITapGestureRecognizer(target: self, action: #selector(closeAccountAction))
        closeAccountView.addGestureRecognizer(tap6)
    }

    private func setupViewsWith(accountInfoModel: AccountInfoModel) {
        // Username
        usernameView.set(placeholderText: R.string.localization.account_info_username(), titleText: accountInfoModel.userName)
        // User ID
        userIdView.set(placeholderText: R.string.localization.account_info_user_id(), titleText: accountInfoModel.userId)
        // Personal ID
        personalIdView.set(placeholderText: R.string.localization.account_info_personal_id(), titleText: accountInfoModel.personalId)
        // Status
        statusView.set(placeholderText: R.string.localization.account_info_status(), titleText: accountInfoModel.status)
        statusView.isClickable = true
        // Password
        passwordView.set(placeholderText: R.string.localization.account_info_password(), titleText: accountInfoModel.password)
        passwordView.isClickable = true
        passwordView.hidesSeparator = true
        // Mail
        mailView.set(placeholderText: R.string.localization.account_info_mail(), titleText: accountInfoModel.email)
        mailView.isClickable = true
        // Phone
        phoneNumberView.set(placeholderText: R.string.localization.account_info_phone_number(), titleText: accountInfoModel.phoneNumber.asPhoneNumber)
        phoneNumberView.isClickable = true
        phoneNumberView.hidesSeparator = true
        // Name
        nameView.set(placeholderText: R.string.localization.account_info_name(), titleText: accountInfoModel.name)
        // Surname
        surnameView.set(placeholderText: R.string.localization.account_info_surname(), titleText: accountInfoModel.surname)
        // Birth Date
        birthDateView.set(placeholderText: R.string.localization.account_info_birth_date(), titleText: accountInfoModel.birthDate)
        // Gender
        genderView.set(placeholderText: R.string.localization.account_info_gender(), titleText: accountInfoModel.gender)
        // Country
        countryView.set(placeholderText: R.string.localization.account_info_country(), titleText: accountInfoModel.country)
        // Address
        addressView.set(placeholderText: R.string.localization.account_info_address(), titleText: accountInfoModel.address)
        addressView.isClickable = true
        addressView.hidesSeparator = true
    }

    // MARK: Action methods
    @objc private func selfSuspendButtonAction () {
        navigator.navigate(to: .selfSuspend, animated: true)
    }

    @objc private func editPasswordAction() {
        navigator.navigate(to: .passwordChange, animated: true)
    }

    @objc private func editMailAction() {
        navigator.navigate(to: .mailChange, animated: true)
    }

    @objc private func editPhoneNumberAction() {
        navigator.navigate(to: .phoneNumberChange, animated: true)
    }

    @objc private func editAddressAction() {
        viewModel.changeAddressTapped()
    }

    @objc private func closeAccountAction() {
        navigator.navigate(to: .closeAccount, animated: true)
    }
}

extension AccountInfoViewController: CommonBarButtonProviding { }
