//
//  AccountParametersHeaderComponentViewModel.swift
//  Mobile
//
//  Created by Irakli Shelia on 12/1/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public protocol AccountParametersHeaderComponentViewModel: AccountParametersHeaderComponentViewModelInput,
                                                AccountParametersHeaderComponentViewModelOutput {}

public struct AccountParametersHeaderComponentViewModelParams {
    let title: String
}

public protocol AccountParametersHeaderComponentViewModelInput {
    func didBind()
}

public protocol AccountParametersHeaderComponentViewModelOutput {
    var action: Observable<AccountParametersHeaderComponentViewModelOutputAction> { get }
    var params: AccountParametersHeaderComponentViewModelParams { get }
}

public enum AccountParametersHeaderComponentViewModelOutputAction {
    case set(params: AccountParametersHeaderComponentViewModelParams)
}

public class DefaultAccountParametersHeaderComponentViewModel {
    public var params: AccountParametersHeaderComponentViewModelParams
    private let actionSubject = PublishSubject<AccountParametersHeaderComponentViewModelOutputAction>()
    public init(params: AccountParametersHeaderComponentViewModelParams) {
        self.params = params
    }
}

extension DefaultAccountParametersHeaderComponentViewModel: AccountParametersHeaderComponentViewModel {
    public var action: Observable<AccountParametersHeaderComponentViewModelOutputAction> {
        actionSubject.asObserver()
    }

    public func didBind() {
        actionSubject.onNext(.set(params: params))
    }
}
