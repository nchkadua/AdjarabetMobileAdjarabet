//
//  HighSecurityViewController.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 6/25/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

class HighSecurityViewController: ABPopupViewController {
    @Inject(from: .viewModels) private var viewModel: HighSecurityViewModel
    private lazy var navigator = HighSecurityNavigator(viewController: self)

    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }

    // MARK: Bind to viewModel's observable properties
    private func bind(to viewModel: HighSecurityViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)

        viewModel.route.subscribe(onNext: { [weak self] route in
            self?.didRecive(route: route)
        }).disposed(by: disposeBag)
    }

    private func didRecive(action: HighSecurityViewModelOutputAction) {
    }

    private func didRecive(route: HighSecurityViewModelRoute) {
    }
}

// MARK: - UIViewControllerTransitioningDelegate
extension HighSecurityViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        ABPopupPresentationController(
            presentedViewController: presented,
            presenting: presenting,
            params: .init(
                heightConstant: 240
            )
        )
    }
}
