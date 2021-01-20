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
    public let selected: Bool
    public let separator: Bool
}

public protocol SecurityLevelTypeComponentViewModelInput {
    func didBind()
}

public protocol SecurityLevelTypeComponentViewModelOutput {
    var action: Observable<SecurityLevelTypeComponentViewModelOutputAction> { get }
    var params: SecurityLevelTypeComponentViewModelParams { get }
}

public enum SecurityLevelTypeComponentViewModelOutputAction {
    case set(title: String, selected: Bool, separator: Bool)
}

public class DefaultSecurityLevelTypeComponentViewModel {
    public var params: SecurityLevelTypeComponentViewModelParams
    public var actionSubject = PublishSubject<SecurityLevelTypeComponentViewModelOutputAction>()
    public init(params: SecurityLevelTypeComponentViewModelParams) {
        self.params = params
    }
}

extension DefaultSecurityLevelTypeComponentViewModel: SecurityLevelTypeComponentViewModel {
    public var action: Observable<SecurityLevelTypeComponentViewModelOutputAction> {
        actionSubject.asObserver()
    }

    public func didBind() {
        actionSubject.onNext(.set(title: params.title, selected: params.selected, separator: params.separator))
    }
}
