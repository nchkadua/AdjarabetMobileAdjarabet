//
//  PaymentMethodComponentViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 3/22/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public protocol PaymentMethodComponentViewModel: PaymentMethodComponentViewModelInput,
                                                PaymentMethodComponentViewModelOutput {}

public struct PaymentMethodComponentViewModelParams {
    public var iconUrl: String
}

public protocol PaymentMethodComponentViewModelInput {
    func didBind()
    func didSelect(at indexPath: IndexPath)
    func select()
    func deselect()
}

public protocol PaymentMethodComponentViewModelOutput {
    var action: Observable<PaymentMethodComponentViewModelOutputAction> { get }
    var params: PaymentMethodComponentViewModelParams { get }
}

public enum PaymentMethodComponentViewModelOutputAction {
    case set(iconUrl: String)
    case didSelect(indexPath: IndexPath)
    case select
    case deselect
}

public class DefaultPaymentMethodComponentViewModel {
    public var params: PaymentMethodComponentViewModelParams
    private let actionSubject = PublishSubject<PaymentMethodComponentViewModelOutputAction>()
    public init(params: PaymentMethodComponentViewModelParams) {
        self.params = params
    }
}

extension DefaultPaymentMethodComponentViewModel: PaymentMethodComponentViewModel {
    public var action: Observable<PaymentMethodComponentViewModelOutputAction> {
        actionSubject.asObserver()
    }

    public func didBind() {
        actionSubject.onNext(.set(iconUrl: params.iconUrl))
    }

    public func didSelect(at indexPath: IndexPath) {
        actionSubject.onNext(.didSelect(indexPath: indexPath))
    }

    public func select() {
        actionSubject.onNext(.select)
    }

    public func deselect() {
        actionSubject.onNext(.deselect)
    }
}
