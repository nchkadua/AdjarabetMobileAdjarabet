//
//  BonusViewController.swift
//  Mobile
//
//  Created by Nika Chkadua on 4/26/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public class BonusViewController: ABViewController {
    @Inject(from: .viewModels) var viewModel: BonusViewModel
    private lazy var navigator = BonusNavigator(viewController: self)

    // MARK: - Lifecycle methods
    public override func viewDidLoad() {
        super.viewDidLoad()
        bind(to: viewModel)
        errorThrowing = viewModel
        viewModel.viewDidLoad()
    }

    // MARK: Bind to viewModel's observable properties
    private func bind(to viewModel: BonusViewModel) {
    }

    private func didRecive(action: BonusViewModelOutputAction) {
    }

    private func didRecive(route: BonusViewModelRoute) {
    }
}
