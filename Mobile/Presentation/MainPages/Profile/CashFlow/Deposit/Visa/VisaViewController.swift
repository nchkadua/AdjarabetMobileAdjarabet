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
        case .placeholdAmount(let placeholder):
            {}() // TODO: Nika update amount input with "placeholder"
        case .updateAmount(let amount):
            {}() // TODO: Nika update amount input with "amount"
        case .updateContinue(let isUserInteractionEnabled):
            {}() // TODO: Nika update isUserInteractionEnabled of continue button
        case .showView(let type):
            handleShowView(of: type)
        case .show(let error):
            {}() // TODO: Nika handle error
        }
    }

    private func handleShowView(of type: VisaViewType) {
        switch type {
        case .accounts(let list, let selectedIndex):
            {}() // TODO: Nika handle account list and selectedIndex
        case .addAccount:
            {}() // TODO: Nika handle visualization of view without accounts
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
