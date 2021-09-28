//
//  DepositViewController.swift
//  Mobile
//
//  Created by Nika Chkadua on 3/22/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public class DepositViewController: ABViewController {
    @Inject(from: .viewModels) var viewModel: DepositViewModel
    private lazy var navigator = DepositNavigator(parent: self, superview: childrenVCFrameView)

    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var depositLabel: UILabel!
    @IBOutlet private weak var balanceTitleLabel: UILabel!
    @IBOutlet private weak var balanceLabel: UILabel!

    @IBOutlet private weak var paymentGridComponentView: PaymentMethodGridComponentView!
    @IBOutlet private weak var childrenVCFrameView: UIView!

    // MARK: - Lifecycle methods
    public override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        bind(to: viewModel)
        errorThrowing = viewModel
        viewModel.viewDidLoad()
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.viewDidAppear()
    }

    // MARK: Bind to viewModel's observable properties
    private func bind(to viewModel: DepositViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)
    }

    private func didRecive(action: DepositViewModelOutputAction) {
        switch action {
        case .set(let totalBalance): set(totalBalance)
        case .bindToGridViewModel(let viewModel): bindToGrid(viewModel)
        case .didLoadPaymentMethods(let methods): navigateToViewController(by: methods[0].flowId)
        case .isLoading(let loading):
            DispatchQueue.main.async { [self] in
                loading ? startLoading() : startLoading()
            }
        }
    }

    // MARK: Setup methods
    private func setup() {
        setBaseBackgroundColor()
        setupLabels()
        setupImageView()
    }

    private func setupImageView() {
        iconImageView.image = R.image.deposit.icon()
    }

    private func setupLabels() {
        setupDepositLabel()
        setupBalanceTitleLabel()
        setupBalanceLabel()
    }

    private func setupDepositLabel() {
        depositLabel.setTextColor(to: .primaryText())
        depositLabel.setFont(to: .callout(fontCase: .upper, fontStyle: .semiBold))
        depositLabel.text = R.string.localization.deposit_deposit_title.localized().uppercased()
    }

    private func setupBalanceTitleLabel() {
        balanceTitleLabel.setTextColor(to: .secondaryText())
        balanceTitleLabel.setFont(to: .footnote(fontCase: .lower, fontStyle: .regular))
        balanceTitleLabel.text = R.string.localization.deposit_balance_title.localized()
    }

    private func setupBalanceLabel() {
        balanceLabel.setTextColor(to: .primaryText())
        balanceLabel.setFont(to: .title2(fontCase: .upper, fontStyle: .semiBold))
    }

    private func set(_ totalBalance: Double) {
        balanceLabel.text = totalBalance.formattedBalanceWithCurrencySign
    }

    /// Payment Grid
    private func bindToGrid(_ viewModel: PaymentMethodGridComponentViewModel) {
        paymentGridComponentView.setAndBind(viewModel: viewModel)
        bind(to: viewModel)
    }

    private func bind(to viewModel: PaymentMethodGridComponentViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)
    }

    private func didRecive(action: PaymentMethodGridComponentViewModelOutputAction) {
        switch action {
        case .didSelectPaymentMethod(let method, _): navigateToViewController(method)
        default:
            break
        }
    }

    // MARK: Action methods
    private func navigateToViewController(_ method: PaymentMethodComponentViewModel) {
        print("ASdadsasds ", method.params.flowId)
        guard let destination = DepositNavigator.Destination(flowId: method.params.flowId) else {
            let message = "Unknown Deposit method"
            self.show(error: .init(type: .`init`(description: .popup(description: .init(description: message)))))
            return
        }
        navigator.navigate(to: destination)
    }

    private func navigateToViewController(by flowId: String) {
        guard let destination = DepositNavigator.Destination(flowId: flowId) else {
            let message = "Unknown Deposit method"
            self.show(error: .init(type: .`init`(description: .popup(description: .init(description: message)))))
            return
        }
        navigator.navigate(to: destination)
    }
}

// MARK: WithdrawNavigator.Destination initializer from flowId
fileprivate extension DepositNavigator.Destination {
    init?(flowId: String) {
        switch flowId {
        case "deposite_tbc_ufc_vip":     self = .visaVip
        case "deposite_tbc_ufc_regular": self = .visaRegular
        case "deposit_applepay":         self = .applePay
        case "deposite_emoney":          self = .emoney
        default: return nil
        }
    }
}
