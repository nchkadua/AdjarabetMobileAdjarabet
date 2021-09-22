//
//  PromoTabComponentViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 22.09.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public protocol PromoTabComponentViewModel: PromoTabComponentViewModelInput,
                                                PromoTabComponentViewModelOutput {}

public struct PromoTabComponentViewModelParams {
}

public protocol PromoTabComponentViewModelInput {
    func didBind()
    func buttonPublicDidTap()
    func buttonPrivateDidTap()
}

public protocol PromoTabComponentViewModelOutput {
    var action: Observable<PromoTabComponentViewModelOutputAction> { get }
    var params: PromoTabComponentViewModelParams { get }
}

public enum PromoTabComponentViewModelOutputAction {
    case buttonPublicDidTap
    case buttonPrivateDidTap
}

public class DefaultPromoTabComponentViewModel {
    public var params: PromoTabComponentViewModelParams
    private let actionSubject = PublishSubject<PromoTabComponentViewModelOutputAction>()
    public init(params: PromoTabComponentViewModelParams) {
        self.params = params
    }
}

extension DefaultPromoTabComponentViewModel: PromoTabComponentViewModel {
    public var action: Observable<PromoTabComponentViewModelOutputAction> {
        actionSubject.asObserver()
    }

    public func didBind() {}

    public func buttonPublicDidTap() {
        actionSubject.onNext(.buttonPublicDidTap)
    }

    public func buttonPrivateDidTap() {
        actionSubject.onNext(.buttonPrivateDidTap)
    }
}
