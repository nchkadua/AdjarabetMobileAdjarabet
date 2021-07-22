//
//  CloseAccountButtonComponentViewModel.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 7/21/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public protocol CloseAccountButtonComponentViewModel: CloseAccountButtonComponentViewModelInput,
                                                CloseAccountButtonComponentViewModelOutput {}

public struct CloseAccountButtonComponentViewModelParams {
}

public protocol CloseAccountButtonComponentViewModelInput {
    func didBind()
    func didSelect()
}

public protocol CloseAccountButtonComponentViewModelOutput {
    var action: Observable<CloseAccountButtonComponentViewModelOutputAction> { get }
    var params: CloseAccountButtonComponentViewModelParams { get }
}

public enum CloseAccountButtonComponentViewModelOutputAction {
    case didSelect
}

public class DefaultCloseAccountButtonComponentViewModel {
    public var params: CloseAccountButtonComponentViewModelParams
    private let actionSubject = PublishSubject<CloseAccountButtonComponentViewModelOutputAction>()
    public init(params: CloseAccountButtonComponentViewModelParams) {
        self.params = params
    }
}

extension DefaultCloseAccountButtonComponentViewModel: CloseAccountButtonComponentViewModel {
    public var action: Observable<CloseAccountButtonComponentViewModelOutputAction> {
        actionSubject.asObserver()
    }

    public func didBind() {
//        actionSubject.onNext()
    }

    public func didSelect() {
        actionSubject.onNext(.didSelect)
    }
}
