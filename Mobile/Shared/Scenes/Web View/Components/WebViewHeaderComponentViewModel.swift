//
//  WebViewHeaderComponentViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 28.09.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public protocol WebViewHeaderComponentViewModel: WebViewHeaderComponentViewModelInput,
                                                WebViewHeaderComponentViewModelOutput {}

public struct WebViewHeaderComponentViewModelParams {
    let shouldNavigate: Bool
    let title: String
}

public protocol WebViewHeaderComponentViewModelInput {
    func didBind()
    func goBack()
    func goForward()
    func refresh()
    func dismiss()
}

public protocol WebViewHeaderComponentViewModelOutput {
    var action: Observable<WebViewHeaderComponentViewModelOutputAction> { get }
    var params: WebViewHeaderComponentViewModelParams { get }
}

public enum WebViewHeaderComponentViewModelOutputAction {
    case setupWith(title: String, navigation: Bool)
    case goBack
    case goForward
    case refresh
    case dismiss
}

public class DefaultWebViewHeaderComponentViewModel {
    public var params: WebViewHeaderComponentViewModelParams
    private let actionSubject = PublishSubject<WebViewHeaderComponentViewModelOutputAction>()
    public init(params: WebViewHeaderComponentViewModelParams) {
        self.params = params
    }
}

extension DefaultWebViewHeaderComponentViewModel: WebViewHeaderComponentViewModel {
    public var action: Observable<WebViewHeaderComponentViewModelOutputAction> {
        actionSubject.asObserver()
    }

    public func didBind() {
        actionSubject.onNext(.setupWith(title: params.title, navigation: params.shouldNavigate))
    }

    public func goBack() {
        actionSubject.onNext(.goBack)
    }

    public func goForward() {
        actionSubject.onNext(.goForward)
    }

    public func refresh() {
        actionSubject.onNext(.refresh)
    }

    public func dismiss() {
        actionSubject.onNext(.dismiss)
    }
}
