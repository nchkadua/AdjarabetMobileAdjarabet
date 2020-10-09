//
//  QuickActionsHeaderViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/9/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public protocol QuickActionsHeaderViewModel: QuickActionsHeaderViewModelInput, QuickActionsHeaderViewModelOutput {
}

public struct QuickActionsHeaderViewModelParams {
}

public protocol QuickActionsHeaderViewModelInput {
    func didBind()
}

public protocol QuickActionsHeaderViewModelOutput {
    var action: Observable<QuickActionsHeaderViewModelOutputAction> { get }
    var params: QuickActionsHeaderViewModelParams { get }
}

public enum QuickActionsHeaderViewModelOutputAction {
    case setTitle(QuickActionsHeaderViewModel)
}

public class DefaultQuickActionsHeaderViewModel {
    public var params: QuickActionsHeaderViewModelParams
    private let actionSubject = PublishSubject<QuickActionsHeaderViewModelOutputAction>()

    public init (params: QuickActionsHeaderViewModelParams) {
        self.params = params
    }
}

extension DefaultQuickActionsHeaderViewModel: QuickActionsHeaderViewModel {
    public var action: Observable<QuickActionsHeaderViewModelOutputAction> { actionSubject.asObserver() }

    public func didBind() {
        actionSubject.onNext(.setTitle(self))
    }
}
