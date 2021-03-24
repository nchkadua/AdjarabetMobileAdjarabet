//
//  VisaViewController.swift
//  Mobile
//
//  Created by Nika Chkadua on 3/23/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

class VisaViewController: UIViewController {
    var viewModel: VisaViewModel!
    private lazy var navigator = VisaNavigator(viewController: self)
    private let disposeBag = DisposeBag()

    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }

    // MARK: Bind to viewModel's observable properties
    private func bind(to viewModel: VisaViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)

        viewModel.route.subscribe(onNext: { [weak self] route in
            self?.didRecive(route: route)
        }).disposed(by: disposeBag)
    }

    private func didRecive(action: VisaViewModelOutputAction) {
        switch action {
        case .showView(let type):
            handleShowView(of: type)
        case .enterAmount(let amount):
            let account = 0 // TODO: Nika specify currentcy chosen account index
            viewModel.entered(amount: amount, account: account)
        case .updateAmount(let amount):
            {}() // TODO: Nika update amount input with "amount"
        case .updateAccounts(let accounts):
            {}() // TODO: Nika update account picker view with "accounts"
        case .updateContinue(let isEnabled):
            {}() // TODO: Nika update isUserInteractionEnabled of continue button
        case .updateMin(let min):
            {}() // TODO: Nika update min amount text
        case .updateDisposable(let disposable):
            {}() // TODO: Nika update min disposable text
        case .updateMax(let max):
            {}() // TODO: Nika update max disposable text
        case .show(error: let error):
            {}() // TODO: Nika handle error
        }
    }

    private func handleShowView(of type: VisaViewType) {
        switch type {
        case .accounts:
            {}() // TODO: Nika handle visualization of view with accounts
        case .addAccount:
            {}() // TODO: Nika handle visualization of add account
        }
    }

    private func didRecive(route: VisaViewModelRoute) {
        switch route {
        case .webView(let params):
            navigator.navigate(to: .webView(params: params))
        case .addAccount:
            navigator.navigate(to: .addAccount)
        }
    }
}
