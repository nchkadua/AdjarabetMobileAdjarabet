//
//  SecurityLevelTypeComponentViewModel.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 12/9/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public protocol SecurityLevelTypeComponentViewModel: SecurityLevelTypeComponentViewModelInput,
                                                     SecurityLevelTypeComponentViewModelOutput { }

public struct SecurityLevelTypeComponentViewModelParams {
    public let title: String
    public var selected: Bool
}

public protocol SecurityLevelTypeComponentViewModelInput {
    func didBind()
    func toggleRequest()
}

public protocol SecurityLevelTypeComponentViewModelOutput {
    var actionSubject: PublishSubject<SecurityLevelTypeComponentViewModelOutputAction> { get set }
    var action: Observable<SecurityLevelTypeComponentViewModelOutputAction> { get }
    var params: SecurityLevelTypeComponentViewModelParams { get }
}

public extension SecurityLevelTypeComponentViewModelOutput {
    public var action: Observable<SecurityLevelTypeComponentViewModelOutputAction> {
        actionSubject.asObserver()
    }
}

public enum SecurityLevelTypeComponentViewModelOutputAction {
    case set(title: String, selected: Bool)
    case toggleRequest
}

public class DefaultSecurityLevelTypeComponentViewModel {
    public var params: SecurityLevelTypeComponentViewModelParams
    public var actionSubject = PublishSubject<SecurityLevelTypeComponentViewModelOutputAction>()
    public init(params: SecurityLevelTypeComponentViewModelParams) {
        self.params = params
    }
}

extension DefaultSecurityLevelTypeComponentViewModel: SecurityLevelTypeComponentViewModel {
    public func didBind() {
        actionSubject.onNext(.set(title: params.title, selected: params.selected))
    }

    public func toggleRequest() {
        actionSubject.onNext(.toggleRequest)
    }
}
