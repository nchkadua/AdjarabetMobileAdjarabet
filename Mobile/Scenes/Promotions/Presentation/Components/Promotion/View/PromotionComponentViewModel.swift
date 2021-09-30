//
//  PromotionComponentViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/8/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public enum PromoType {
    case publicPromo(promo: PublicPromosEntity.PublicPromo)
    case privatePromo(promo: PrivatePromosEntity.PrivatePromo)
}

public protocol PromotionComponentViewModel: PromotionComponentViewModelInput, PromotionComponentViewModelOutput {
}

public struct PromotionComponentViewModelParams {
    public var promoType: PromoType
}

public protocol PromotionComponentViewModelInput {
    func didBind()
}

public protocol PromotionComponentViewModelOutput {
    var action: Observable<PromotionComponentViewModelOutputAction> { get }
    var params: PromotionComponentViewModelParams { get }
}

public enum PromotionComponentViewModelOutputAction {
    case setUpWithPublicPromo(promo: PublicPromosEntity.PublicPromo)
    case setUpWithPrivatePromo(promo: PrivatePromosEntity.PrivatePromo)
}

public class DefaultPromotionComponentViewModel {
    public var params: PromotionComponentViewModelParams
    private let actionSubject = PublishSubject<PromotionComponentViewModelOutputAction>()

    public init (params: PromotionComponentViewModelParams) {
        self.params = params
    }
}

extension DefaultPromotionComponentViewModel: PromotionComponentViewModel {
    public var action: Observable<PromotionComponentViewModelOutputAction> { actionSubject.asObserver() }

    public func didBind() {
        switch params.promoType {
        case .publicPromo(let publicPromo): actionSubject.onNext(.setUpWithPublicPromo(promo: publicPromo))
        case .privatePromo(let privatePromo): actionSubject.onNext(.setUpWithPrivatePromo(promo: privatePromo))
        }
    }
}
