//
//  DocumentationViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 06.07.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public protocol DocumentationViewModel: DocumentationViewModelInput, DocumentationViewModelOutput {
}

public struct DocumentationViewModelParams {
}

public protocol DocumentationViewModelInput: AnyObject {
    var params: DocumentationViewModelParams { get set }
    func viewDidLoad()
    func createPrivacyPolicyRequest()
}

public protocol DocumentationViewModelOutput {
    var action: Observable<DocumentationViewModelOutputAction> { get }
    var route: Observable<DocumentationViewModelRoute> { get }
}

public enum DocumentationViewModelOutputAction {
    case initialize(AppListDataProvider)
}

public enum DocumentationViewModelRoute {
    case openPage(destionation: DocumentationDestination)
    case navigateToPrivacyPolicy(params: WebViewModelParams)
}

public class DefaultDocumentationViewModel: DefaultBaseViewModel {
    public var params: DocumentationViewModelParams
    private let actionSubject = PublishSubject<DocumentationViewModelOutputAction>()
    private let routeSubject = PublishSubject<DocumentationViewModelRoute>()
    private var httpRequestBuilder: HttpRequestBuilder { HttpRequestBuilderImpl.createInstance() }

    public init(params: DocumentationViewModelParams) {
        self.params = params
    }
}

extension DefaultDocumentationViewModel: DocumentationViewModel {
    public var action: Observable<DocumentationViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<DocumentationViewModelRoute> { routeSubject.asObserver() }

    public func viewDidLoad() {
        setupActions()
    }

    private func setupActions() {
        var dataProviders: AppCellDataProviders = []

        ActionItemsProvider.items().forEach {
            let actionViewModel = DefaultDocumentationActionComponentViewModel(params: .init(title: $0.title, destination: $0.destination))

            actionViewModel.action.subscribe(onNext: { [weak self] action in
                switch action {
                case .didSelect: self?.routeSubject.onNext(.openPage(destionation: actionViewModel.params.destination))
                default: break
                }
            }).disposed(by: self.disposeBag)

            dataProviders.append(actionViewModel)
        }
        actionSubject.onNext(.initialize(dataProviders.makeList()))
    }

    public func createPrivacyPolicyRequest() {
        //TODO change url
        let request = httpRequestBuilder.set(host: "https://www.adjarabet.com/" + languageStorage.currentLanguage.localizableIdentifier + "/Privacy")
            .set(method: HttpMethodGet())
            .build()
        routeSubject.onNext(.navigateToPrivacyPolicy(params: .init(request: request)))
    }
}