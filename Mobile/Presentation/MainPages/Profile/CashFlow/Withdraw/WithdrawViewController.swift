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
    private lazy var navigator = WithdrawNavigator(parent: self, superview: childView)

    // MARK: Outlets
    @IBOutlet private weak var cashOutLabel: UILabel!
    @IBOutlet private weak var balanceLabel: UILabel!
    @IBOutlet private weak var amountLabel: UILabel!
    @IBOutlet private weak var payments: PaymentMethodGridComponentView!
    @IBOutlet private weak var childView: UIView!
    @IBOutlet private weak var loader: UIActivityIndicatorView!

    // MARK: - Lifecycle methods
    public override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bind(to: viewModel)
        viewModel.viewDidLoad()
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

    private func didRecive(action: WithdrawViewModelOutputAction) {
        switch action {
        case .loader(let isHidden):
            handleLoader(isHidden)
        case .set(let balance):
            amountLabel.text = balance
        case .bind(let viewModel):
            payments.setAndBind(viewModel: viewModel)
        case .show(let error):
            showAlert(title: error)
        }
    }

    private func didRecive(route: WithdrawViewModelRoute) {
        switch route {
        case .navigate(let destination):
            navigator.navigate(to: destination)
        }
    }

    // MARK: Setup methods
    private func setup() {
        setBaseBackgorundColor()
        setupKeyboard()
        setupLabels()
        loader.isHidden = true // initially hide loader
    }

    private func setupLabels() {
        cashOutLabel.setTextColor(to: .primaryText())
        cashOutLabel.setFont(to: .callout(fontCase: .upper, fontStyle: .semiBold))
        cashOutLabel.text = R.string.localization.withdraw_cash_out.localized().uppercased()

        balanceLabel.setTextColor(to: .secondaryText())
        balanceLabel.setFont(to: .footnote(fontCase: .lower, fontStyle: .regular))
        balanceLabel.text = R.string.localization.withdraw_balance.localized()

        amountLabel.setTextColor(to: .primaryText())
        amountLabel.setFont(to: .title2(fontCase: .upper, fontStyle: .semiBold))
    }

    private func handleLoader(_ isHidden: Bool) {
        loader.isHidden = isHidden
        (isHidden ? loader.stopAnimating : loader.startAnimating)()
    }
}
