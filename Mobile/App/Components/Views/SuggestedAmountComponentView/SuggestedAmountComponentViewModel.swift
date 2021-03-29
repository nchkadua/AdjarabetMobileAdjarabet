//
//  SuggestedAmountComponentViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 3/29/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public protocol SuggestedAmountComponentViewModel: SuggestedAmountComponentViewModelInput,
                                                SuggestedAmountComponentViewModelOutput {}

public struct SuggestedAmountComponentViewModelParams {
    public var amount: Double
}

public protocol SuggestedAmountComponentViewModelInput {
    func didBind()
    func didSelect(at indexPath: IndexPath)
}

public protocol SuggestedAmountComponentViewModelOutput {
    var action: Observable<SuggestedAmountComponentViewModelOutputAction> { get }
    var params: SuggestedAmountComponentViewModelParams { get }
}

public enum SuggestedAmountComponentViewModelOutputAction {
    case set(amount: Double)
    case didSelect(indexPath: IndexPath)
}

public class DefaultSuggestedAmountComponentViewModel {
    public var params: SuggestedAmountComponentViewModelParams
    private let actionSubject = PublishSubject<SuggestedAmountComponentViewModelOutputAction>()
    public init(params: SuggestedAmountComponentViewModelParams) {
        self.params = params
    }
}

extension DefaultSuggestedAmountComponentViewModel: SuggestedAmountComponentViewModel {
    public var action: Observable<SuggestedAmountComponentViewModelOutputAction> {
        actionSubject.asObserver()
    }

    public func didBind() {
        actionSubject.onNext(.set(amount: params.amount))
    }

    public func didSelect(at indexPath: IndexPath) {
        actionSubject.onNext(.didSelect(indexPath: indexPath))
    }
}
