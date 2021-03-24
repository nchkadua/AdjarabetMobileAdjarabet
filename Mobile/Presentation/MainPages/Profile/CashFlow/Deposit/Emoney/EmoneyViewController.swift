//
//  EmoneyViewController.swift
//  Mobile
//
//  Created by Nika Chkadua on 3/23/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

class EmoneyViewController: UIViewController {
    @Inject(from: .viewModels) var viewModel: EmoneyViewModel
    private lazy var navigator = EmoneyNavigator(viewController: self)
    private let disposeBag = DisposeBag()

    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        bind(to: viewModel)
    }

    // MARK: Bind to viewModel's observable properties
    private func bind(to viewModel: EmoneyViewModel) {
        viewModel.route.subscribe(onNext: { [weak self] route in
            self?.didRecive(route: route)
        }).disposed(by: disposeBag)
    }

    private func didRecive(route: EmoneyViewModelRoute) {
        switch route {
        case .navigate(let params):
            navigator.navigate(to: .webView(with: params))
        }
    }

    @IBAction func navigateTapped() { viewModel.navigate() }
}
