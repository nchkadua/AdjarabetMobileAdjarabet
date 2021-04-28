//
//  BonusViewController.swift
//  Mobile
//
//  Created by Nika Chkadua on 4/26/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public class BonusViewController: UIViewController {
    @Inject(from: .viewModels) public var viewModel: BonusViewModel
    public lazy var navigator = BonusNavigator(viewController: self)
    private let disposeBag = DisposeBag()

    // MARK: - Lifecycle methods
    public override func viewDidLoad() {
        super.viewDidLoad()

        bind(to: viewModel)
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
