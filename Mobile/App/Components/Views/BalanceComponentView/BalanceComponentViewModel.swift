//
//  BalanceComponentViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/6/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public protocol BalanceComponentViewModel: BalanceComponentViewModelInput, BalanceComponentViewModelOutput {
}

public struct BalanceComponentViewModelParams {
    public var totalBalance: Double
    public var pokerBalance: Double
}

public protocol BalanceComponentViewModelInput {
    func didBind()
    func didClickBalance()
    func didClickWithdraw()
    func didClickDeposit()
}

public protocol BalanceComponentViewModelOutput {
    var action: Observable<BalanceComponentViewModelOutputAction> { get }
    var params: BalanceComponentViewModelParams { get }
}

public enum BalanceComponentViewModelOutputAction {
    case set(totalBalance: Double, pokerBalance: Double)
    case didClickBalance(BalanceComponentViewModel)
    case didClickWithdraw(BalanceComponentViewModel)
    case didClickDeposit(BalanceComponentViewModel)
}

public class DefaultBalanceComponentViewModel {
    public var params: BalanceComponentViewModelParams
    private let actionSubject = PublishSubject<BalanceComponentViewModelOutputAction>()

    public init (params: BalanceComponentViewModelParams) {
        self.params = params
    }
}

extension DefaultBalanceComponentViewModel: BalanceComponentViewModel {
    public var action: Observable<BalanceComponentViewModelOutputAction> { actionSubject.asObserver() }

    public func didBind() {
        actionSubject.onNext(.set(totalBalance: params.totalBalance, pokerBalance: params.pokerBalance))
    }

    public func didClickBalance() {
        actionSubject.onNext(.didClickBalance(self))
    }

    public func didClickWithdraw() {
        actionSubject.onNext(.didClickWithdraw(self))
    }

    public func didClickDeposit() {
        actionSubject.onNext(.didClickDeposit(self))
    }
}
