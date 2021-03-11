//
//  DepositViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/28/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public protocol DepositViewModel: DepositViewModelInput, DepositViewModelOutput {
}

public protocol DepositViewModelInput {
    func viewDidLoad()
    func addCard()
}

public protocol DepositViewModelOutput {
    var action: Observable<DepositViewModelOutputAction> { get }
    var route: Observable<DepositViewModelRoute> { get }
}

public enum DepositViewModelOutputAction {
    case setupWithLabel(_ label: LabelComponentViewModel)
    case setupPaymentMethods(_ payment: Payment)
}

public enum DepositViewModelRoute {
}

public class DefaultDepositViewModel {
    private let actionSubject = PublishSubject<DepositViewModelOutputAction>()
    private let routeSubject = PublishSubject<DepositViewModelRoute>()

    @Inject public var userBalanceService: UserBalanceService
    @Inject(from: .useCases) private var paymentListUseCase: PaymentListUseCase
}

extension DefaultDepositViewModel: DepositViewModel {
    public var action: Observable<DepositViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<DepositViewModelRoute> { routeSubject.asObserver() }

    public func viewDidLoad() {
        actionSubject.onNext(.setupWithLabel(LabelComponentViewModel(title: R.string.localization.balance_title(), value: "\(userBalanceService.balance?.formattedBalance ?? "0.0") ₾")))
        actionSubject.onNext(.setupPaymentMethods(Payment()))
    }

    public func addCard() {
    }
}
