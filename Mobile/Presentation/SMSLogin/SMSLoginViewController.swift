//
//  SMSLoginViewController.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 5/13/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public class SMSLoginViewController: ABViewController {
    public var viewModel: SMSLoginViewModel!
    public lazy var navigator = SMSLoginNavigator(viewController: self)

    // MARK: IBOutlets
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var smsLoginTitleLabel: UILabel!
    @IBOutlet private weak var smsLoginDescriptionLabel: UILabel!
    @IBOutlet private weak var resentSMSButton: ABButton!
    @IBOutlet private weak var loginButton: ABButton!
    @IBOutlet private weak var notMemberLabel: UILabel!
    @IBOutlet private weak var joinNowButton: ABButton!

    // MARK: - Lifecycle methods
    public override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }

    // MARK: Bind to viewModel's observable properties
    private func bind(to viewModel: SMSLoginViewModel) {
//        viewModel.action.subscribe(onNext: { [weak self] action in
//            self?.didRecive(action: action)
//        }).disposed(by: disposeBag)
//
//        viewModel.route.subscribe(onNext: { [weak self] route in
//            self?.didRecive(route: route)
//        }).disposed(by: disposeBag)
    }

    private func didRecive(action: SMSLoginViewModelOutputAction) {
    }

    private func didRecive(route: SMSLoginViewModelRoute) {
    }

    // MAKR: Setup methods
    private func setup() {
        setBaseBackgorundColor()
        setupNavigationItem()
        setupScrollView()
        setupLabels()
        setupButtons()
    }

    private func setupNavigationItem() {
        setBackBarButtonItemIfNeeded(width: 26)
        navigationController?.navigationBar.barTintColor = view.backgroundColor
    }

    private func setupScrollView() {
        scrollView.alwaysBounceVertical = true
    }

    private func setupLabels() {
        smsLoginTitleLabel.setTextColor(to: .white())
        smsLoginTitleLabel.setFont(to: .h2(fontCase: .lower))
        smsLoginTitleLabel.text = "SMS Login"

        smsLoginDescriptionLabel.setTextColor(to: .neutral100(alpha: 0.8))
        smsLoginDescriptionLabel.attributedText = "We sent a confirmation code to your mobile phone number (+995 599 23 98 49)".makeAttributedString(with: .p, lineSpasing: 4)

        notMemberLabel.setTextColor(to: .neutral100(alpha: 0.6))
        notMemberLabel.setFont(to: .h4(fontCase: .lower))
        notMemberLabel.text = "Not a member?"
    }

    private func setupButtons() {
        resentSMSButton.setSize(to: .none)
        resentSMSButton.setStyle(to: .textLink(state: .acvite))
        resentSMSButton.setTitleColor(to: .neutral100(alpha: 0.6), for: .normal)
        resentSMSButton.setTitleWithoutAnimation("Resend SMS", for: .normal)
        resentSMSButton.addTarget(self, action: #selector(resentSMSDidTap), for: .touchUpInside)

        loginButton.setSize(to: .large)
        loginButton.setStyle(to: .primary(state: .disabled))
        loginButton.setTitleWithoutAnimation("LOG IN", for: .normal)
        loginButton.addTarget(self, action: #selector(loginDidTap), for: .touchUpInside)

        joinNowButton.setSize(to: .medium)
        joinNowButton.setStyle(to: .ghost(state: .acvite))
        joinNowButton.setTitleWithoutAnimation("Join now", for: .normal)
        joinNowButton.contentEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 0)
        joinNowButton.addTarget(self, action: #selector(joinNowDidTap), for: .touchUpInside)
    }

    // MARK: Actions
    @objc private func joinNowDidTap() {
        showAlert(title: "Join now")
    }

    @objc private func resentSMSDidTap() {
        showAlert(title: "Resend SMS")
    }

    @objc private func loginDidTap() {
        showAlert(title: "Log in")
    }
}
