//
//  LogOutComponentViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 6/22/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public protocol LogOutComponentViewModel: LogOutComponentViewModelInput,
                                                LogOutComponentViewModelOutput {}

public struct LogOutComponentViewModelParams {
    public var title: String
}

public protocol LogOutComponentViewModelInput {
    func didBind()
    func didTapButton()
}

public protocol LogOutComponentViewModelOutput {
    var action: Observable<LogOutComponentViewModelOutputAction> { get }
    var params: LogOutComponentViewModelParams { get }
}

public enum LogOutComponentViewModelOutputAction {
    case set(title: String)
    case didTapButton
}

public class DefaultLogOutComponentViewModel {
    public var params: LogOutComponentViewModelParams
    private let actionSubject = PublishSubject<LogOutComponentViewModelOutputAction>()
    public init(params: LogOutComponentViewModelParams) {
        self.params = params
    }
}

extension DefaultLogOutComponentViewModel: LogOutComponentViewModel {
    public var action: Observable<LogOutComponentViewModelOutputAction> {
        actionSubject.asObserver()
    }

    public func didBind() {
        actionSubject.onNext(.set(title: params.title))
    }

    public func didTapButton() {
        actionSubject.onNext(.didTapButton)
    }
}
