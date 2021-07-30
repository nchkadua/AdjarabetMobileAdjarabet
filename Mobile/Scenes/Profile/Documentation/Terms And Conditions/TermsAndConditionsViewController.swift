//
//  TermsAndConditionsViewController.swift
//  Mobile
//
//  Created by Giga Khizanishvili on 30.07.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public class TermsAndConditionsViewController: UIViewController {
    @Inject(from: .viewModels) public var viewModel: TermsAndConditionsViewModel
    public lazy var navigator = TermsAndConditionsNavigator(viewController: self)
    private let disposeBag = DisposeBag()

    // MARK: - Lifecycle methods
    public override func viewDidLoad() {
        super.viewDidLoad()

        bind(to: viewModel)
        viewModel.viewDidLoad()
    }

    // MARK: Bind to viewModel's observable properties
    private func bind(to viewModel: TermsAndConditionsViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)

        viewModel.route.subscribe(onNext: { [weak self] route in
            self?.didRecive(route: route)
        }).disposed(by: disposeBag)
    }

    private func didRecive(action: TermsAndConditionsViewModelOutputAction) {
    }
    
    private func didRecive(route: TermsAndConditionsViewModelRoute) {
    }
}
