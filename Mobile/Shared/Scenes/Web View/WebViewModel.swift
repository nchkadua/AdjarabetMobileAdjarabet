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
    public let canNavigate: Bool

    public init(loadType: LoadType, canNavigate: Bool) {
        self.loadType = loadType
        self.canNavigate = canNavigate
    }
}

public protocol WebViewModelInput: AnyObject {
    var params: WebViewModelParams { get set }
    func viewDidLoad()
    func subscribeTo(_ viewModel: WebViewHeaderComponentViewModel)
    func activateHeaderBackButton()
}

public protocol WebViewModelOutput {
    var action: Observable<WebViewModelOutputAction> { get }
    var route: Observable<WebViewModelRoute> { get }
}

public enum WebViewModelOutputAction {
    case loadRequst(_ request: URLRequest)
    case loadHtml(_ html: String)
    case bindToHeaderViewModel(viewModel: WebViewHeaderComponentViewModel, navigateionEnabled: Bool)
    case dismiss
    case goBack
    case goForward
    case reload
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
        actionSubject.onNext(.bindToHeaderViewModel(viewModel: webViewHeaderComponentViewModel, navigateionEnabled: params.canNavigate))

        switch params.loadType {
        case .urlRequst(let request): actionSubject.onNext(.loadRequst(request))
        case .html(let html): actionSubject.onNext(.loadHtml(html))
        }
    }

    public func subscribeTo(_ viewModel: WebViewHeaderComponentViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)
    }

    private func didRecive(action: WebViewHeaderComponentViewModelOutputAction) {
        switch action {
        case .dismiss: actionSubject.onNext(.dismiss)
        case .goBack: actionSubject.onNext(.goBack)
        case .goForward: actionSubject.onNext(.goForward)
        case .reload: actionSubject.onNext(.reload)
        default:
            break
        }
    }

    public func activateHeaderBackButton() {
        webViewHeaderComponentViewModel.activateBackButton()
    }
}
