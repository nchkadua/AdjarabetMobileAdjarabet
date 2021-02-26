//
//  HomeBannerContainerComponentViewModel.swift
//  Mobile
//
//  Created by Irakli Shelia on 2/22/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public protocol HomeBannerContainerComponentViewModel: HomeBannerContainerComponentViewModelInput,
                                                HomeBannerContainerComponentViewModelOutput {}

public struct HomeBannerContainerComponentViewModelParams {
    let banners: [AppCellDataProvider]
}

public protocol HomeBannerContainerComponentViewModelInput {
    func didBind()
}

public protocol HomeBannerContainerComponentViewModelOutput {
    var action: Observable<HomeBannerContainerComponentViewModelOutputAction> { get }
    var params: HomeBannerContainerComponentViewModelParams { get }
}

public enum HomeBannerContainerComponentViewModelOutputAction {
    case set(banners: [AppCellDataProvider])
}

public class DefaultHomeBannerContainerComponentViewModel {
    public var params: HomeBannerContainerComponentViewModelParams
    private let actionSubject = PublishSubject<HomeBannerContainerComponentViewModelOutputAction>()
    public init(params: HomeBannerContainerComponentViewModelParams) {
        self.params = params
    }
}

extension DefaultHomeBannerContainerComponentViewModel: HomeBannerContainerComponentViewModel {
    public var action: Observable<HomeBannerContainerComponentViewModelOutputAction> {
        actionSubject.asObserver()
    }

    public func didBind() {
        actionSubject.onNext(.set(banners: params.banners))
    }
}
