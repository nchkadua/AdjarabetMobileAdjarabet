//
//  BiometricSettingsViewController.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 11/17/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public class BiometricSettingsViewController: ABPopupViewController {
    @Inject(from: .viewModels)
    public var viewModel: BiometricSettingsViewModel
    public lazy var navigator = BiometricSettingsNavigator(viewController: self)

    // MARK: - Lifecycle methods
    public override func viewDidLoad() {
        super.viewDidLoad()
        bind(to: viewModel)
        viewModel.viewDidLoad()
        view.backgroundColor = .gray
    }

    // MARK: Bind to viewModel's observable properties
    private func bind(to viewModel: BiometricSettingsViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)

        viewModel.route.subscribe(onNext: { [weak self] route in
            self?.didRecive(route: route)
        }).disposed(by: disposeBag)
    }

    private func didRecive(action: BiometricSettingsViewModelOutputAction) {
    }

    private func didRecive(route: BiometricSettingsViewModelRoute) {
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension BiometricSettingsViewController: UIViewControllerTransitioningDelegate {
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        ABPopupPresentationController(
            presentedViewController: presented,
            presenting: presenting,
            params: .init(
                heightConstant: 400
            )
        )
    }
}
