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

public enum LoadType {
    case urlRequst(request: URLRequest)
    case html(html: String)
}

public struct WebViewModelParams {
    public let loadType: LoadType

    public init(loadType: LoadType) {
        self.loadType = loadType
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
    case loadRequst(_ request: URLRequest)
    case loadHtml(_ html: String)
    case bindToGridViewModel(viewModel: WebViewHeaderComponentViewModel)
}

public enum WebViewModelRoute {
}

public class DefaultWebViewModel: DefaultBaseViewModel {
    public var params: WebViewModelParams
    private let actionSubject = PublishSubject<WebViewModelOutputAction>()
    private let routeSubject = PublishSubject<WebViewModelRoute>()
    
    @Inject(from: .componentViewModels) private var webViewHeaderComponentViewModel: WebViewHeaderComponentViewModel

    public init(params: WebViewModelParams) {
        self.params = params
    }
}

extension DefaultWebViewModel: WebViewModel {
    public var action: Observable<WebViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<WebViewModelRoute> { routeSubject.asObserver() }

    public func viewDidLoad() {
        actionSubject.onNext(.bindToGridViewModel(viewModel: webViewHeaderComponentViewModel))
        
        switch params.loadType {
        case .urlRequst(let request): actionSubject.onNext(.loadRequst(request))
        case .html(let html): actionSubject.onNext(.loadHtml(html))
        }
    }
}
