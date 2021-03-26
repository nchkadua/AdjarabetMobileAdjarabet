//
//  DepositViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 3/22/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public protocol DepositViewModel: DepositViewModelInput, DepositViewModelOutput {
}

public struct DepositViewModelParams {
}

public protocol DepositViewModelInput: AnyObject {
    var params: DepositViewModelParams { get set }
    func viewDidLoad()
}

public protocol DepositViewModelOutput {
    var action: Observable<DepositViewModelOutputAction> { get }
    var route: Observable<DepositViewModelRoute> { get }
}

public enum DepositViewModelOutputAction {
    case set(totalBalance: Double)
    case bindToGridViewModel(viewModel: PaymentMethodGridComponentViewModel)
    case didLoadPaymentMethods(methods: [PaymentMethodEntity])
    case showMessage(message: String)
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
        actionSubject.onNext(.set(totalBalance: userBalanceService.balance ?? 0.0))
        actionSubject.onNext(.bindToGridViewModel(viewModel: paymentGridComponentViewModel))

        // fetch payment list
        paymentListUseCase.list { [weak self] result in
            switch result {
            case .success(let entity):
                let viewModels: [PaymentMethodCollectionViewCellDataProvider] = entity.filter { $0.flowId.contains("deposit") }.compactMap { payment in
                    let vm = DefaultPaymentMethodComponentViewModel(params: .init(iconUrl: payment.iconUrl, flowId: payment.flowId))
                    return vm
                }

                self?.paymentGridComponentViewModel.reloadCollectionView(with: viewModels)
                self?.actionSubject.onNext(.didLoadPaymentMethods(methods: entity))
            case .failure(let error): self?.actionSubject.onNext(.showMessage(message: error.localizedDescription))
            }
        }
    }
}
