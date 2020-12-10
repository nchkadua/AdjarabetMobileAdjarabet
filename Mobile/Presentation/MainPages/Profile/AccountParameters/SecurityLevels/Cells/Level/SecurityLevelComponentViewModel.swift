//
//  SecurityLevelComponentViewModel.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 12/9/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public protocol SecurityLevelComponentViewModel: SecurityLevelComponentViewModelInput,
                                                 SecurityLevelComponentViewModelOutput { }

public struct SecurityLevelComponentViewModelParams {
    public let title: String
    public var selected: Bool
}

public protocol SecurityLevelComponentViewModelInput {
    func didBind()
    func toggleRequest()
}

public protocol SecurityLevelComponentViewModelOutput {
    var action: Observable<SecurityLevelComponentViewModelOutputAction> { get }
    var params: SecurityLevelComponentViewModelParams { get }
}

public enum SecurityLevelComponentViewModelOutputAction {
    case set(title: String, selected: Bool)
    case toggleRequest
}

public class DefaultSecurityLevelComponentViewModel {
    public var params: SecurityLevelComponentViewModelParams
    private let actionSubject = PublishSubject<SecurityLevelComponentViewModelOutputAction>()
    public init(params: SecurityLevelComponentViewModelParams) {
        self.params = params
    }
}

extension DefaultSecurityLevelComponentViewModel: SecurityLevelComponentViewModel {
    public var action: Observable<SecurityLevelComponentViewModelOutputAction> {
        actionSubject.asObserver()
    }

    public func didBind() {
        actionSubject.onNext(.set(title: params.title, selected: params.selected))
    }

    public func toggleRequest() {
        actionSubject.onNext(.toggleRequest)
    }
}
