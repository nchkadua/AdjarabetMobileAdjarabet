//
//  WithdrawVisaViewController.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 4/5/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

class WithdrawVisaViewController: ABViewController {
    var viewModel: WithdrawVisaViewModel!
    private lazy var navigator = WithdrawVisaNavigator(viewController: self)

    @IBOutlet private weak var mainContentView: UIView!
    @IBOutlet private weak var infoView: WithdrawVisaInfoView!

    private lazy var cashOutView = CashOutVisaView()
    private lazy var addAccountView: AddAccountView = {
        let view = AddAccountView()
        view.button.addTarget(self, action: #selector(added), for: .touchUpInside)
        return view
    }()

    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        bind(to: viewModel)
        errorThrowing = viewModel
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
        case .isLoading(let loading):
            loading ? startLoading() : stopLoading()
        }
    }

    private func didRecive(route: WithdrawVisaViewModelRoute) {
        switch route {
        case .addAccount(let params):
            navigator.navigate(to: .addAccount(params: params))
        }
    }

    private func handleLoader(isHidden: Bool) {
        mainContentView.isHidden = !isHidden
        infoView.isHidden = !isHidden
    }

    private func handleShowView(of type: WithdrawViewType) {
        switch type {
        case .accounts: show(cashOutView)
        case .addAccount: show(addAccountView)
        }
    }

    @objc private func added() {
        viewModel.added()
    }

    private func show(_ view: UIView) {
        mainContentView.removeAllSubViews()
        mainContentView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.pin(to: mainContentView)
    }
}
