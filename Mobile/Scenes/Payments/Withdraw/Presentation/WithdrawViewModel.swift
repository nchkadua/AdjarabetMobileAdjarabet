//
//  WithdrawViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/28/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

protocol WithdrawViewModel: BaseViewModel, WithdrawViewModelInput, WithdrawViewModelOutput { }

protocol WithdrawViewModelInput {
    func viewDidLoad()
}

protocol WithdrawViewModelOutput {
    var action: Observable<WithdrawViewModelOutputAction> { get }
    var route: Observable<WithdrawViewModelRoute> { get }
}

enum WithdrawViewModelOutputAction {
    case loader(isHidden: Bool)
    case set(balance: String)
    case bind(viewModel: PaymentMethodGridComponentViewModel)
}

enum WithdrawViewModelRoute {
    case navigate(to: WithdrawNavigator.Destination)
}

class DefaultWithdrawViewModel: DefaultBaseViewModel {
    private let actionSubject = PublishSubject<WithdrawViewModelOutputAction>()
    private let routeSubject = PublishSubject<WithdrawViewModelRoute>()

    @Inject private var userBalanceService: UserBalanceService
    private let paymentListUseCase: WithdrawPaymentListUseCase = DefaultWithdrawPaymentListUseCase()
    @Inject(from: .useCases) private var amountFormatter: AmountFormatterUseCase
    @Inject(from: .componentViewModels) private var paymentsViewModel: PaymentMethodGridComponentViewModel
}

extension DefaultWithdrawViewModel: WithdrawViewModel {
    var action: Observable<WithdrawViewModelOutputAction> { actionSubject.asObserver() }
    var route: Observable<WithdrawViewModelRoute> { routeSubject.asObserver() }

    func viewDidLoad() {
        bind(to: paymentsViewModel)
        observeBalance()
        notify(.loader(isHidden: false))
        notify(.set(balance: userBalanceService.balance?.formattedBalanceWithCurrencySign ?? "-"))
        notify(.bind(viewModel: paymentsViewModel))
        // fetch payment list
        paymentListUseCase.list { [weak self] result in
            guard let self = self else { return }
            self.notify(.loader(isHidden: true))
            switch result {
            case .success(let entity):
                if entity.isEmpty {
                    let message = "No withdraw payment methods was specified"
                    self.show(error: .init(type: .`init`(description: .popup(description: .init(description: message)))))
                } else {
                    let viewModels = entity.map { DefaultPaymentMethodComponentViewModel(params: .init(iconUrl: $0.iconUrl, flowId: $0.flowId)) }
                    self.paymentsViewModel.reloadCollectionView(with: viewModels)
                    // assumption: by default first is selected
                    // simulate didSelectPaymentMethod for first element
                    self.didRecive(action: .didSelectPaymentMethod(viewModels[0], .init(row: 0, section: 0)))
                }
            case .failure(let error):
                self.show(error: error)
            }
        }
    }

    private func observeBalance() {
        userBalanceService.balanceObservable.subscribe(onNext: { [weak self] balance in
            guard let self = self else { return }
            self.notify(.set(balance: self.userBalanceService.balance?.formattedBalanceWithCurrencySign ?? "-"))
        }).disposed(by: disposeBag)
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
                let message = "Unknown withdraw method"
                self.show(error: .init(type: .`init`(description: .popup(description: .init(description: message)))))
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
