//
//  DepositViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 3/22/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

protocol DepositViewModel: BaseViewModel, DepositViewModelInput, DepositViewModelOutput {
}

public struct DepositViewModelParams {
}

public protocol DepositViewModelInput: AnyObject {
    var params: DepositViewModelParams { get set }
    func viewDidLoad()
    func updateBalance()
    func getPaymentMethods()
    func subscribeTo(visaViewModelParams: VisaViewModelParams)
}

public protocol DepositViewModelOutput {
    var action: Observable<DepositViewModelOutputAction> { get }
    var route: Observable<DepositViewModelRoute> { get }
}

public enum DepositViewModelOutputAction {
    case set(totalBalance: Double)
    case bindToGridViewModel(viewModel: PaymentMethodGridComponentViewModel)
    case didLoadPaymentMethods(methods: [PaymentMethodEntity])
    case isLoading(loading: Bool)
}

public enum DepositViewModelRoute {
}

public class DefaultDepositViewModel: DefaultBaseViewModel {
    public var params: DepositViewModelParams
    private let actionSubject = PublishSubject<DepositViewModelOutputAction>()
    private let routeSubject = PublishSubject<DepositViewModelRoute>()

    @Inject private var userBalanceService: UserBalanceService
    @Inject(from: .useCases) private var paymentListUseCase: PaymentListUseCase
    @Inject(from: .componentViewModels) private var paymentGridComponentViewModel: PaymentMethodGridComponentViewModel

    public init(params: DepositViewModelParams) {
        self.params = params
    }
}

extension DefaultDepositViewModel: DepositViewModel {
    public var action: Observable<DepositViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<DepositViewModelRoute> { routeSubject.asObserver() }

    public func viewDidLoad() {
        updateBalance()
        getPaymentMethods()
    }

    public func subscribeTo(visaViewModelParams: VisaViewModelParams) {
        visaViewModelParams.paramsOutputAction.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)
    }

    private func didRecive(action: VisaViewModelParams.Action) {
        switch action {
        case .shouldUpdatePage:
            updateBalance()
            print("asdadasdasdas")
        }
    }

    public func updateBalance() {
        actionSubject.onNext(.set(totalBalance: userBalanceService.balance ?? 0.0))
    }

    public func getPaymentMethods() {
        notify(.isLoading(loading: true))
        actionSubject.onNext(.bindToGridViewModel(viewModel: paymentGridComponentViewModel))

        // fetch payment list
        paymentListUseCase.list { [weak self] result in
            self?.notify(.isLoading(loading: false))
            switch result {
            case .success(let entity):
                let viewModels: [PaymentMethodCollectionViewCellDataProvider] = entity.filter { $0.flowId.contains("deposit") }.compactMap { payment in
                    let vm = DefaultPaymentMethodComponentViewModel(params: .init(iconUrl: payment.iconUrl, flowId: payment.flowId))
                    return vm
                }

                self?.paymentGridComponentViewModel.reloadCollectionView(with: viewModels)
                self?.actionSubject.onNext(.didLoadPaymentMethods(methods: entity))
            case .failure(let error):
                self?.show(error: error)
            }
        }
    }

    private func notify(_ action: DepositViewModelOutputAction) {
        actionSubject.onNext(action)
    }
}
