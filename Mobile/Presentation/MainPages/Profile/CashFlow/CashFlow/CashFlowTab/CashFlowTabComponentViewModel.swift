//
//  CashFlowTabComponentViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/29/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public protocol CashFlowTabComponentViewModel: CashFlowTabComponentViewModelInput, CashFlowTabComponentViewModelOutput {
}

public protocol CashFlowTabComponentViewModelInput {
    func didBind()
    func selectButton(at index: Int, animate: Bool)
}

public protocol CashFlowTabComponentViewModelOutput {
    var action: Observable<CashFlowTabComponentViewModelOutputAction> { get }
}

public enum CashFlowTabComponentViewModelOutputAction {
    case didSelectButton(atIndex: Int, animate: Bool)
}

public class DefaultCashFlowTabComponentViewModel {
    private let actionSubject = PublishSubject<CashFlowTabComponentViewModelOutputAction>()
}

extension DefaultCashFlowTabComponentViewModel: CashFlowTabComponentViewModel {
    public var action: Observable<CashFlowTabComponentViewModelOutputAction> { actionSubject.asObserver() }

    public func didBind() {
    }

    public func selectButton(at index: Int, animate: Bool) {
        actionSubject.onNext(.didSelectButton(atIndex: index, animate: animate))
    }
}
