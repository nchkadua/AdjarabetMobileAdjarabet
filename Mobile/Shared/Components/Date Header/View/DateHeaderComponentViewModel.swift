//
//  DateHeaderComponentViewModel.swift
//  Mobile
//
//  Created by Irakli Shelia on 11/17/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public protocol DateHeaderComponentViewModel: DateHeaderComponentViewModelInput,
                                                               DateHeaderComponentViewModelOutput {}

public struct DateHeaderComponentViewModelParams {
    public let title: String
}

public protocol DateHeaderComponentViewModelInput {
    func didBind()
}

public protocol DateHeaderComponentViewModelOutput {
    var action: Observable<DateHeaderComponentViewModelOutputAction> { get }
    var params: DateHeaderComponentViewModelParams { get }
}

public enum DateHeaderComponentViewModelOutputAction {
    case set(title: String)
}

public class DefaultDateHeaderComponentViewModel {
    public var params: DateHeaderComponentViewModelParams
    private let actionSubject = PublishSubject<DateHeaderComponentViewModelOutputAction>()
    public init(params: DateHeaderComponentViewModelParams) {
        self.params = params
    }
}

extension DefaultDateHeaderComponentViewModel: DateHeaderComponentViewModel {
    public var action: Observable<DateHeaderComponentViewModelOutputAction> {
        actionSubject.asObserver()
    }

    public func didBind() {
        actionSubject.onNext(.set(title: params.title))
    }
}
