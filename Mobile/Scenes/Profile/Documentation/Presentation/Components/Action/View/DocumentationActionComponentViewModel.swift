//
//  DocumentationActionComponentViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 06.07.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public protocol DocumentationActionComponentViewModel: DocumentationActionComponentViewModelInput,
                                                DocumentationActionComponentViewModelOutput {}

public struct DocumentationActionComponentViewModelParams {
    public var title: String
    public var destination: DocumentationDestination
}

public protocol DocumentationActionComponentViewModelInput {
    func didBind()
    func didSelect(at indexPath: IndexPath)
}

public protocol DocumentationActionComponentViewModelOutput {
    var action: Observable<DocumentationActionComponentViewModelOutputAction> { get }
    var params: DocumentationActionComponentViewModelParams { get }
}

public enum DocumentationActionComponentViewModelOutputAction {
    case set(title: String)
    case didSelect(indexPath: IndexPath)
}

public class DefaultDocumentationActionComponentViewModel {
    public var params: DocumentationActionComponentViewModelParams
    private let actionSubject = PublishSubject<DocumentationActionComponentViewModelOutputAction>()
    public init(params: DocumentationActionComponentViewModelParams) {
        self.params = params
    }
}

extension DefaultDocumentationActionComponentViewModel: DocumentationActionComponentViewModel {
    public var action: Observable<DocumentationActionComponentViewModelOutputAction> {
        actionSubject.asObserver()
    }

    public func didBind() {
        actionSubject.onNext(.set(title: params.title))
    }

    public func didSelect(at indexPath: IndexPath) {
        actionSubject.onNext(.didSelect(indexPath: indexPath))
    }
}
