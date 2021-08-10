//
//  WebViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 3/10/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

protocol WebViewModel: BaseViewModel, WebViewModelInput, WebViewModelOutput {
}

public struct WebViewModelParams {
    public let request: URLRequest

    public init(request: URLRequest) {
        self.request = request
    }
}

public protocol WebViewModelInput: AnyObject {
    var params: WebViewModelParams { get set }
    func viewDidLoad()
}

public protocol WebViewModelOutput {
    var action: Observable<WebViewModelOutputAction> { get }
    var route: Observable<WebViewModelRoute> { get }
}

public enum WebViewModelOutputAction {
    case load(_ request: URLRequest)
}

public enum WebViewModelRoute {
}

public class DefaultWebViewModel: DefaultBaseViewModel {
    public var params: WebViewModelParams
    private let actionSubject = PublishSubject<WebViewModelOutputAction>()
    private let routeSubject = PublishSubject<WebViewModelRoute>()

    public init(params: WebViewModelParams) {
        self.params = params
    }
}

extension DefaultWebViewModel: WebViewModel {
    public var action: Observable<WebViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<WebViewModelRoute> { routeSubject.asObserver() }

    public func viewDidLoad() {
        actionSubject.onNext(.load(params.request))
    }
}
