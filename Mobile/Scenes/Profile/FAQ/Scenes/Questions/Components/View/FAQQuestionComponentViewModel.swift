//
//  FAQQuestionComponentViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 20.07.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public protocol FAQQuestionComponentViewModel: FAQQuestionComponentViewModelInput,
                                                FAQQuestionComponentViewModelOutput {}

public struct FAQQuestionComponentViewModelParams {
    let question: String
}

public protocol FAQQuestionComponentViewModelInput {
    func didBind()
    func didSelect(at indexPath: IndexPath)
}

public protocol FAQQuestionComponentViewModelOutput {
    var action: Observable<FAQQuestionComponentViewModelOutputAction> { get }
    var params: FAQQuestionComponentViewModelParams { get }
}

public enum FAQQuestionComponentViewModelOutputAction {
    case set(title: String)
    case didSelect(indexPath: IndexPath)
}

public class DefaultFAQQuestionComponentViewModel {
    public var params: FAQQuestionComponentViewModelParams
    private let actionSubject = PublishSubject<FAQQuestionComponentViewModelOutputAction>()
    public init(params: FAQQuestionComponentViewModelParams) {
        self.params = params
    }
}

extension DefaultFAQQuestionComponentViewModel: FAQQuestionComponentViewModel {
    public var action: Observable<FAQQuestionComponentViewModelOutputAction> {
        actionSubject.asObserver()
    }

    public func didBind() {
        actionSubject.onNext(.set(title: params.question))
    }

    public func didSelect(at indexPath: IndexPath) {
        actionSubject.onNext(.didSelect(indexPath: indexPath))
    }
}
