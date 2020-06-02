//
//  LoadingComponentViewModel.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 6/1/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public protocol LoadingComponentViewModel: LoadingComponentViewModelInput, LoadingComponentViewModelOutput {
}

public struct LoadingComponentViewModelParams {
    public let tintColor: DesignSystem.Color
    public let height: CGFloat
    public var isLoading: Bool = false

    public var normalizedHeight: CGFloat { isLoading ? height : 0 }
}

public protocol LoadingComponentViewModelInput {
    func didBind()
    func set(isLoading: Bool)
}

public protocol LoadingComponentViewModelOutput {
    var action: Observable<LoadingComponentViewModelOutputAction> { get }
    var route: Observable<LoadingComponentViewModelRoute> { get }
    var params: LoadingComponentViewModelParams { get }
}

public enum LoadingComponentViewModelOutputAction {
    case setTintColor(UIColor)
}

public enum LoadingComponentViewModelRoute {
}

public class DefaultLoadingComponentViewModel {
    private let actionSubject = PublishSubject<LoadingComponentViewModelOutputAction>()
    private let routeSubject = PublishSubject<LoadingComponentViewModelRoute>()
    public var params: LoadingComponentViewModelParams

    public init(params: LoadingComponentViewModelParams) {
        self.params = params
    }
}

extension DefaultLoadingComponentViewModel: LoadingComponentViewModel {
    public var action: Observable<LoadingComponentViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<LoadingComponentViewModelRoute> { routeSubject.asObserver() }

    public func didBind() {
        actionSubject.onNext(.setTintColor(params.tintColor.value))
    }

    public func set(isLoading: Bool) {
        self.params.isLoading = isLoading
    }
}
