//
//  PromotionComponentViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/8/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public protocol PromotionComponentViewModel: PromotionComponentViewModelInput, PromotionComponentViewModelOutput {
}

public struct PromotionComponentViewModelParams {
    public var title: String
    public var cover: UIImage
    public var icon: UIImage
}

public protocol PromotionComponentViewModelInput {
    func didBind()
}

public protocol PromotionComponentViewModelOutput {
    var action: Observable<PromotionComponentViewModelOutputAction> { get }
    var params: PromotionComponentViewModelParams { get }
}

public enum PromotionComponentViewModelOutputAction {
    case set(title: String, cover: UIImage, icon: UIImage)
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
        actionSubject.onNext(.set(title: params.title, cover: params.cover, icon: params.icon))
    }
}
