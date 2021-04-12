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
    case loader(show: Bool)
    case set(balance: String)
    case bind(viewModel: PaymentMethodGridComponentViewModel)
    case show(error: String)
}

enum WithdrawViewModelRoute {
    case navigate(to: WithdrawNavigator.Destination)
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
        notify(.loader(show: true))
        notify(.set(balance: userBalanceService.balance?.formattedBalanceWithCurrencySign ?? "-"))
        notify(.bind(viewModel: paymentsViewModel))
        // fetch payment list
        paymentListUseCase.list { [weak self] result in
            guard let self = self else { return }
            self.notify(.loader(show: false))
            switch result {
            case .success(let entity):
                if entity.isEmpty {
                    self.notify(.show(error: "No withdraw payment methods was specified"))
                } else {
                    let viewModels = entity.map { DefaultPaymentMethodComponentViewModel(params: .init(iconUrl: $0.iconUrl, flowId: $0.flowId)) }
                    self.paymentsViewModel.reloadCollectionView(with: viewModels)
                    // assumption: by default first is selected
                    // simulate didSelectPaymentMethod for first element
                    self.didRecive(action: .didSelectPaymentMethod(viewModels[0], .init(row: 0, section: 0)))
                }
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
            guard let destination = WithdrawNavigator.Destination(flowId: viewModel.params.flowId)
            else {
                notify(.show(error: "Unknown withdraw method"))
                return
            }
            routeSubject.onNext(.navigate(to: destination))
        default: break
        }
    }

    private func notify(_ action: WithdrawViewModelOutputAction) {
        actionSubject.onNext(action)
    }
}

// MARK: WithdrawNavigator.Destination initializer from flowId
fileprivate extension WithdrawNavigator.Destination {
    init?(flowId: String) {
        switch flowId {
        case "withdraw_tbc_ufc_vip":     self = .visaVip
        case "withdraw_tbc_ufc_regular": self = .visaRegular
        // TODO: add more cases
        default: return nil
        }
    }
}
