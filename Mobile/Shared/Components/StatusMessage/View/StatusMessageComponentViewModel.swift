//
//  StatusMessageComponentViewModel.swift
//  Mobile
//
//  Created by Giga Khizanishvili on 06.09.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public protocol StatusMessageComponentViewModel: StatusMessageComponentViewModelInput,
                                                StatusMessageComponentViewModelOutput {}

public struct StatusMessageComponentViewModelParams {
    var status: String
}

public protocol StatusMessageComponentViewModelInput {
    func didBind()
}

public protocol StatusMessageComponentViewModelOutput {
    var action: Observable<StatusMessageComponentViewModelOutputAction> { get }
    var params: StatusMessageComponentViewModelParams { get }
}

public enum StatusMessageComponentViewModelOutputAction {
    
}

public class DefaultStatusMessageComponentViewModel {
    public var params: StatusMessageComponentViewModelParams
    private let actionSubject = PublishSubject<StatusMessageComponentViewModelOutputAction>()
    public init(params: StatusMessageComponentViewModelParams) {
        self.params = params
    }
}

extension DefaultStatusMessageComponentViewModel: StatusMessageComponentViewModel {
    public var action: Observable<StatusMessageComponentViewModelOutputAction> {
        actionSubject.asObserver()
    }

    public func didBind() {
//        actionSubject.onNext()
    }
}
