//
//  NewPasswordViewController.swift
//  Mobile
//
//  Created by Nika Chkadua on 30.06.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public class NewPasswordViewController: UIViewController {
    @Inject(from: .viewModels) public var viewModel: NewPasswordViewModel
    public lazy var navigator = NewPasswordNavigator(viewController: self)
    private let disposeBag = DisposeBag()

    // MARK: - Lifecycle methods
    public override func viewDidLoad() {
        super.viewDidLoad()

        bind(to: viewModel)
        viewModel.viewDidLoad()
    }

    // MARK: Bind to viewModel's observable properties
    private func bind(to viewModel: NewPasswordViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)

        viewModel.route.subscribe(onNext: { [weak self] route in
            self?.didRecive(route: route)
        }).disposed(by: disposeBag)
    }

    private func didRecive(action: NewPasswordViewModelOutputAction) {
    }

    private func didRecive(route: NewPasswordViewModelRoute) {
    }
}
