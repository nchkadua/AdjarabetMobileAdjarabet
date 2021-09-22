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
	public var balancePlaceholder: String
	public var isBalanceShown: Bool

	public init(totalBalance: Double, pokerBalance: Double, balancePlaceholder: String, isBalanceShown: Bool = true) {
		self.totalBalance = totalBalance
		self.pokerBalance = pokerBalance
		self.balancePlaceholder = balancePlaceholder
		self.isBalanceShown = isBalanceShown
	}
}

public protocol BalanceComponentViewModelInput {
    func didBind()
    func didClickWithdraw()
    func didClickDeposit()
	func hideBalance()
	func showBalance()
}

public protocol BalanceComponentViewModelOutput {
    var action: Observable<BalanceComponentViewModelOutputAction> { get }
    var params: BalanceComponentViewModelParams { get }
	var formattedAmount: String { get }
	var isBalanceShown: Bool { get }
}

public enum BalanceComponentViewModelOutputAction {
    case didClickWithdraw(BalanceComponentViewModel)
    case didClickDeposit(BalanceComponentViewModel)
	case setup(BalanceComponentViewModel)
	case showTotalBalance
	case showBalancePlaceholder(String)
}

public class DefaultBalanceComponentViewModel {
    public var params: BalanceComponentViewModelParams
    private let actionSubject = PublishSubject<BalanceComponentViewModelOutputAction>()
    @Inject(from: .useCases) private var amountFormatter: AmountFormatterUseCase

    public init (params: BalanceComponentViewModelParams) {
        self.params = params
    }
}

extension DefaultBalanceComponentViewModel: BalanceComponentViewModel {
    public var action: Observable<BalanceComponentViewModelOutputAction> { actionSubject.asObserver() }

	public var formattedAmount: String {
		get {
			amountFormatter.format(number: params.totalBalance, in: .s_n_a)
		}
	}

	public var isBalanceShown: Bool {
		get {
			params.isBalanceShown
		}
	}

    public func didBind() {
        actionSubject.onNext(.setup(self))
    }

    public func didClickWithdraw() {
        actionSubject.onNext(.didClickWithdraw(self))
    }

    public func didClickDeposit() {
        actionSubject.onNext(.didClickDeposit(self))
    }

	public func hideBalance() {
		params.isBalanceShown = false
		actionSubject.onNext(.showBalancePlaceholder(params.balancePlaceholder))
	}

	public func showBalance() {
		params.isBalanceShown = true
		actionSubject.onNext(.showTotalBalance)
	}
}
