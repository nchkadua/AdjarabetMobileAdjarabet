//
//  HomeBannerComponentViewModel.swift
//  Mobile
//
//  Created by Irakli Shelia on 2/22/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public protocol HomeBannerComponentViewModel: HomeBannerComponentViewModelInput,
                                                HomeBannerComponentViewModelOutput {}

public struct HomeBannerComponentViewModelParams {
    
}

public protocol HomeBannerComponentViewModelInput {
    func didBind()
}

public protocol HomeBannerComponentViewModelOutput {
    var action: Observable<HomeBannerComponentViewModelOutputAction> { get }
    var params: HomeBannerComponentViewModelParams { get }
}

public enum HomeBannerComponentViewModelOutputAction {
    
}

public class DefaultHomeBannerComponentViewModel {
    public var params: HomeBannerComponentViewModelParams
    private let actionSubject = PublishSubject<HomeBannerComponentViewModelOutputAction>()
    public init(params: HomeBannerComponentViewModelParams) {
        self.params = params
    }
}

extension DefaultHomeBannerComponentViewModel: HomeBannerComponentViewModel {
    public var action: Observable<HomeBannerComponentViewModelOutputAction> {
        actionSubject.asObserver()
    }

    public func didBind() {
//        actionSubject.onNext()
    }
}
