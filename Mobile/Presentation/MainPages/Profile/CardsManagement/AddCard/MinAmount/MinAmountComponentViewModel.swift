//
//  MinAmountComponentViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 12/3/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public protocol MinAmountComponentViewModel: MinAmountComponentViewModelInput, MinAmountComponentViewModelOutput {
}

public protocol MinAmountComponentViewModelInput {
    func didBind()
    func didClickMinimumAmountButton()
}

public protocol MinAmountComponentViewModelOutput {
    var action: Observable<MinAmountComponentViewModelOutputAction> { get }
}

public enum MinAmountComponentViewModelOutputAction {
    case didClickMinimumAmountButton(_ minimumAmount: Double)
}

public class DefaultMinAmountComponentViewModel {
    private let actionSubject = PublishSubject<MinAmountComponentViewModelOutputAction>()
}

extension DefaultMinAmountComponentViewModel: MinAmountComponentViewModel {
    public var action: Observable<MinAmountComponentViewModelOutputAction> { actionSubject.asObserver() }

    public func didBind() {
    }

    public func didClickMinimumAmountButton() {
        actionSubject.onNext(.didClickMinimumAmountButton(1.0))
    }
}
