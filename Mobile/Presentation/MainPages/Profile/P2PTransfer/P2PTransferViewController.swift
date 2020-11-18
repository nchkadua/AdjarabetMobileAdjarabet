//
//  P2PTransferViewController.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 11/18/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public class P2PTransferViewController: ABViewController {
    @Inject(from: .viewModels) public var viewModel: P2PTransferViewModel
    public lazy var navigator = P2PTransferNavigator(viewController: self)

    // MARK: - Lifecycle methods
    public override func viewDidLoad() {
        super.viewDidLoad()
        bind(to: viewModel)
        viewModel.viewDidLoad()
        view.backgroundColor = .purple
    }

    // MARK: Bind to viewModel's observable properties
    private func bind(to viewModel: P2PTransferViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)

        viewModel.route.subscribe(onNext: { [weak self] route in
            self?.didRecive(route: route)
        }).disposed(by: disposeBag)
    }

    private func didRecive(action: P2PTransferViewModelOutputAction) {
    }

    private func didRecive(route: P2PTransferViewModelRoute) {
    }
}
