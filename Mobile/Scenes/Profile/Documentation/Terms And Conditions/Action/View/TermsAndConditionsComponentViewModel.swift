//
//  TermsAndConditionsComponentViewModel.swift
//  Mobile
//
//  Created by Giga Khizanishvili on 02.08.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public protocol TermsAndConditionsComponentViewModel: TermsAndConditionsComponentViewModelInput,
                                                      TermsAndConditionsComponentViewModelOutput {}

public struct TermsAndConditionsComponentViewModelParams {
    public var number: Int
    public var title: String
//    public var destination: TermsAndConditionsDest
}

public protocol TermsAndConditionsComponentViewModelInput {
    func didBind()
    func didSelect(at indexPath: IndexPath)
}

public protocol TermsAndConditionsComponentViewModelOutput {
    var action: Observable<TermsAndConditionsComponentViewModelOutputAction> { get }
    var params: TermsAndConditionsComponentViewModelParams { get }
}

public enum TermsAndConditionsComponentViewModelOutputAction {
    case set(number: Int, title: String)
    case didSelect(indexPath: IndexPath)
}

public class DefaultTermsAndConditionsComponentViewModel {
    public var params: TermsAndConditionsComponentViewModelParams
    private let actionSubject = PublishSubject<TermsAndConditionsComponentViewModelOutputAction>()
    public init(params: TermsAndConditionsComponentViewModelParams) {
        self.params = params
    }
}

extension DefaultTermsAndConditionsComponentViewModel: TermsAndConditionsComponentViewModel {
    
    public var action: Observable<TermsAndConditionsComponentViewModelOutputAction> {
        actionSubject.asObserver()
    }

    public func didBind() {
        actionSubject.onNext(.set(number: params.number, title: params.title))
    }
    
    public func didSelect(at indexPath: IndexPath) {
        actionSubject.onNext(.didSelect(indexPath: indexPath))
    }
}
