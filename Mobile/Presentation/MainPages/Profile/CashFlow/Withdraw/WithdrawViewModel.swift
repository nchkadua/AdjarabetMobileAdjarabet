//
//  WithdrawViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/28/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public protocol WithdrawViewModel: WithdrawViewModelInput, WithdrawViewModelOutput {
}

public protocol WithdrawViewModelInput {
    func viewDidLoad()
    func textDidChange(to text: String?)
}

public protocol WithdrawViewModelOutput {
    var action: Observable<WithdrawViewModelOutputAction> { get }
    var route: Observable<WithdrawViewModelRoute> { get }
}

public enum WithdrawViewModelOutputAction {
    case setupWithLabel(_ label: LabelComponentViewModel)
    case setupPaymentMethods(_ payment: Payment)
    case updateCommission(_ value: String)
    case updateTotalAmount(_ value: String)
}

public enum WithdrawViewModelRoute {
}

public class DefaultWithdrawViewModel {
    private let actionSubject = PublishSubject<WithdrawViewModelOutputAction>()
    private let routeSubject = PublishSubject<WithdrawViewModelRoute>()

    @Inject public var userBalanceService: UserBalanceService
}

extension DefaultWithdrawViewModel: WithdrawViewModel {
    public var action: Observable<WithdrawViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<WithdrawViewModelRoute> { routeSubject.asObserver() }

    public func viewDidLoad() {
        actionSubject.onNext(.setupWithLabel(LabelComponentViewModel(title: R.string.localization.balance_title(), value: "\(userBalanceService.balance?.formattedBalance ?? "0.0") ₾")))
        actionSubject.onNext(.setupPaymentMethods(Payment()))
    }

    public func textDidChange(to text: String?) {
        let amount = Double(text ?? "0.0") ?? 0.0
        let commission = ABConstant.countCommission(of: amount)
        let totalAmount = amount + commission

        actionSubject.onNext(.updateCommission(String(commission.rounded(to: 2))))
        actionSubject.onNext(.updateTotalAmount(String(totalAmount.rounded(to: 2))))
    }
}
