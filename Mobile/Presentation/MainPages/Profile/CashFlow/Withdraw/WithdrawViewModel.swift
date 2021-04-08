//
//  WithdrawViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/28/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

protocol WithdrawViewModel: WithdrawViewModelInput, WithdrawViewModelOutput { }

protocol WithdrawViewModelInput {
    func viewDidLoad()
}

protocol WithdrawViewModelOutput {
    var action: Observable<WithdrawViewModelOutputAction> { get }
    var route: Observable<WithdrawViewModelRoute> { get }
}

enum WithdrawViewModelOutputAction {
    case set(balance: String)
    case bind(viewModel: PaymentMethodGridComponentViewModel)
    case show(error: String)
}

enum WithdrawViewModelRoute {
}

class DefaultWithdrawViewModel {
    private let actionSubject = PublishSubject<WithdrawViewModelOutputAction>()
    private let routeSubject = PublishSubject<WithdrawViewModelRoute>()

    @Inject private var userBalanceService: UserBalanceService
    private let paymentListUseCase: WithdrawPaymentListUseCase = DefaultWithdrawPaymentListUseCase()
    @Inject(from: .useCases) private var amountFormatter: AmountFormatterUseCase
    @Inject(from: .componentViewModels) private var paymentsViewModel: PaymentMethodGridComponentViewModel
    private let disposeBag = DisposeBag()
}

extension DefaultWithdrawViewModel: WithdrawViewModel {
    var action: Observable<WithdrawViewModelOutputAction> { actionSubject.asObserver() }
    var route: Observable<WithdrawViewModelRoute> { routeSubject.asObserver() }

    func viewDidLoad() {
        bind(to: paymentsViewModel)
        notify(.set(balance: userBalanceService.balance?.formattedBalanceWithCurrencySign ?? "-"))
        notify(.bind(viewModel: paymentsViewModel))
        // fetch payment list
        paymentListUseCase.list { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let entity):
                self.paymentsViewModel.reloadCollectionView(with: entity.map {
                    DefaultPaymentMethodComponentViewModel(params: .init(iconUrl: $0.iconUrl, flowId: $0.flowId))
                })
            case .failure(let error):
                self.notify(.show(error: error.localizedDescription))
            }
        }
    }

    private func bind(to viewModel: PaymentMethodGridComponentViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)
    }

    private func didRecive(action: PaymentMethodGridComponentViewModelOutputAction) {
        switch action {
        case .didSelectPaymentMethod(let viewModel, _):
            {}() // Decide where to navigate
        default:
            break
        }
    }

    private func notify(_ action: WithdrawViewModelOutputAction) {
        actionSubject.onNext(action)
    }
}
