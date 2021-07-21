//
//  CloseAccountViewController.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 7/21/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public class CloseAccountViewController: UIViewController {
    @Inject(from: .viewModels) public var viewModel: CloseAccountViewModel
    public lazy var navigator = CloseAccountNavigator(viewController: self)
    private let disposeBag = DisposeBag()

    @IBOutlet private weak var popup: UIView!

    // MARK: - Lifecycle methods
    public override func viewDidLoad() {
        super.viewDidLoad()

        UIView.animate(withDuration: 0.4) {
            self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        }
        //hideNavBar()
        popup.isHidden = true
        DispatchQueue.main.async {
            UIView.transition(
                with: self.popup,
                duration: 0.4,
                options: .transitionCrossDissolve,
                animations: {
                    self.popup.isHidden = false
                }
            )
        }

        bind(to: viewModel)
        viewModel.viewDidLoad()
    }

    // MARK: Bind to viewModel's observable properties
    private func bind(to viewModel: CloseAccountViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)

        viewModel.route.subscribe(onNext: { [weak self] route in
            self?.didRecive(route: route)
        }).disposed(by: disposeBag)
    }

    private func didRecive(action: CloseAccountViewModelOutputAction) {
    }

    private func didRecive(route: CloseAccountViewModelRoute) {
    }
}
