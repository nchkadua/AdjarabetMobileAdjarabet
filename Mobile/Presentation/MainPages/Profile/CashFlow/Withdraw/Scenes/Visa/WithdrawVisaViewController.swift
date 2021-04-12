//
//  WithdrawVisaViewController.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 4/5/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

class WithdrawVisaViewController: UIViewController {
    var viewModel: WithdrawVisaViewModel!
    private lazy var navigator = WithdrawVisaNavigator(viewController: self)
    private let disposeBag = DisposeBag()

    @IBOutlet private weak var mainContentView: UIView!
    @IBOutlet private weak var infoView: WithdrawVisaInfoView!

    private lazy var cashOutView = CashOutVisaView()

    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        bind(to: viewModel)
        viewModel.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            guard let self = self else { return }
            self.mainContentView.addSubview(self.cashOutView)
            self.cashOutView.translatesAutoresizingMaskIntoConstraints = false
            self.cashOutView.pin(to: self.mainContentView)
        }
    }

    // MARK: Bind to viewModel's observable properties
    private func bind(to viewModel: WithdrawVisaViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)

        viewModel.route.subscribe(onNext: { [weak self] route in
            self?.didRecive(route: route)
        }).disposed(by: disposeBag)
    }

    private func didRecive(action: WithdrawVisaViewModelOutputAction) {
    }

    private func didRecive(route: WithdrawVisaViewModelRoute) {
    }
}
