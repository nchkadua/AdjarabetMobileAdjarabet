//
//  WithdrawVisaViewController.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 4/5/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

class WithdrawVisaViewController: UIViewController {
    var viewModel: WithdrawVisaViewModel!
    private lazy var navigator = WithdrawVisaNavigator(viewController: self)
    private let disposeBag = DisposeBag()

    @IBOutlet private weak var mainContentView: UIView!
    @IBOutlet private weak var infoView: WithdrawVisaInfoView!

    private lazy var cashOutView = CashOutVisaView()
    private lazy var addAccountView = AddAccountView()

    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }

    // MARK: Bind to viewModel's observable properties
    private func bind(to viewModel: WithdrawVisaViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)

        viewModel.route.subscribe(onNext: { [weak self] route in
            self?.didRecive(route: route)
        }).disposed(by: disposeBag)
    }

    private func didRecive(action: WithdrawVisaViewModelOutputAction) {
        switch action {
        case .showView(let type):
            handleShowView(of: type)
        case .setAndBindCashOut(let viewModel):
            cashOutView.setAndBind(viewModel: viewModel)
        case .setAndBindInfo(let viewModel):
            infoView.setAndBind(viewModel: viewModel)
        case .show(let error):
            showAlert(title: error)
        case .showMessage(let message):
            showAlert(title: message)
        }
    }

    private func didRecive(route: WithdrawVisaViewModelRoute) {
        switch route {
        case .addAccount:
            {}()
        }
    }

    private func handleShowView(of type: WithdrawViewType) {
        switch type {
        case .accounts: show(cashOutView)
        case .addAccount: show(addAccountView)
        }
    }

    private func show(_ view: UIView) {
        mainContentView.removeAllSubViews()
        mainContentView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.pin(to: mainContentView)
    }
}
