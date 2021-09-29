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
}

public protocol WebViewHeaderComponentViewModelInput {
    func didBind()
    func set(_ title: String, _ shouldNavigate: Bool)
    func activateBackButton()
    func goBack()
    func goForward()
    func reload()
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
    case reload
    case dismiss
    case activateBackButton
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

    public func didBind() {}

    public func set(_ title: String, _ shouldNavigate: Bool) {
        actionSubject.onNext(.setupWith(title: title, navigation: shouldNavigate))
    }

    public func goBack() {
        actionSubject.onNext(.goBack)
    }

    public func goForward() {
        actionSubject.onNext(.goForward)
    }

    public func reload() {
        actionSubject.onNext(.reload)
    }

    public func dismiss() {
        actionSubject.onNext(.dismiss)
    }

    public func activateBackButton() {
        actionSubject.onNext(.activateBackButton)
    }
}
