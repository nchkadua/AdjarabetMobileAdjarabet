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
    
}

public protocol TermsAndConditionsComponentViewModelInput {
    func didBind()
}

public protocol TermsAndConditionsComponentViewModelOutput {
    var action: Observable<TermsAndConditionsComponentViewModelOutputAction> { get }
    var params: TermsAndConditionsComponentViewModelParams { get }
}

public enum TermsAndConditionsComponentViewModelOutputAction {
    
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
//        actionSubject.onNext()
    }
}
