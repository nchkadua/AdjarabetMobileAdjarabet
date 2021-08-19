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
}

public protocol EmptyPageComponentViewModelOutput {
    var action: Observable<EmptyPageComponentViewModelOutputAction> { get }
    var params: EmptyPageComponentViewModelParams { get }
}

public enum EmptyPageComponentViewModelOutputAction {
}

public class DefaultEmptyPageComponentViewModel {
    public var params: EmptyPageComponentViewModelParams
    private let actionSubject = PublishSubject<EmptyPageComponentViewModelOutputAction>()
    public init(params: EmptyPageComponentViewModelParams) {
        self.params = params
    }
}

extension DefaultEmptyPageComponentViewModel: EmptyPageComponentViewModel {
    public var action: Observable<EmptyPageComponentViewModelOutputAction> {
        actionSubject.asObserver()
    }

    public func didBind() {
//        actionSubject.onNext()
    }
}
