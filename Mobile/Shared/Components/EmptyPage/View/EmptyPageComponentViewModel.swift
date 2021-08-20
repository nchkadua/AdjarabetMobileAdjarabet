//
//  EmptyPageComponentViewModel.swift
//  Mobile
//
//  Created by Giga Khizanishvili on 13.08.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public protocol EmptyPageComponentViewModel: EmptyPageComponentViewModelInput,
                                                EmptyPageComponentViewModelOutput {}

public struct EmptyPageComponentViewModelParams {
    public let icon: UIImage
    public let title: String
    public let description: String
}

public protocol EmptyPageComponentViewModelInput {
    func didBind()
    func set(title: String)
}

public protocol EmptyPageComponentViewModelOutput {
    var action: Observable<EmptyPageComponentViewModelOutputAction> { get }
    var params: EmptyPageComponentViewModelParams { get }
}

public enum EmptyPageComponentViewModelOutputAction {
    case titleUpdate(title: String)
}

public class DefaultEmptyPageComponentViewModel {
    public var params: EmptyPageComponentViewModelParams
    private let actionSubject = PublishSubject<EmptyPageComponentViewModelOutputAction>()
    public init(params: EmptyPageComponentViewModelParams) {
        self.params = params
    }
}

extension DefaultEmptyPageComponentViewModel: EmptyPageComponentViewModel {
    public func set(title: String) {
        actionSubject.onNext(.titleUpdate(title: title))
    }
    
    public var action: Observable<EmptyPageComponentViewModelOutputAction> {
        actionSubject.asObserver()
    }

    public func didBind() {
//        actionSubject.onNext()
    }
}
