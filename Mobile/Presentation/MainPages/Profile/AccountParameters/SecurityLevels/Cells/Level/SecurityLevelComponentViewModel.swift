//
//  SecurityLevelComponentViewModel.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 12/9/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

protocol SecurityLevelComponentViewModel: SecurityLevelComponentViewModelInput,
                                          SecurityLevelComponentViewModelOutput { }

struct SecurityLevelComponentViewModelParams {
    let title: String
    let selected: Bool
    let separator: Bool
    let corners: RoundCorners

    enum RoundCorners {
        case none
        case top
        case bottom
    }
}

protocol SecurityLevelComponentViewModelInput {
    func didBind()
}

protocol SecurityLevelComponentViewModelOutput {
    var action: Observable<SecurityLevelComponentViewModelOutputAction> { get }
    var params: SecurityLevelComponentViewModelParams { get }
}

enum SecurityLevelComponentViewModelOutputAction {
    case set(params: SecurityLevelComponentViewModelParams)
}

class DefaultSecurityLevelComponentViewModel {
    var params: SecurityLevelComponentViewModelParams
    private let actionSubject = PublishSubject<SecurityLevelComponentViewModelOutputAction>()
    init(params: SecurityLevelComponentViewModelParams) {
        self.params = params
    }
}

extension DefaultSecurityLevelComponentViewModel: SecurityLevelComponentViewModel {
    var action: Observable<SecurityLevelComponentViewModelOutputAction> {
        actionSubject.asObserver()
    }

    func didBind() {
        actionSubject.onNext(.set(params: params))
    }
}
