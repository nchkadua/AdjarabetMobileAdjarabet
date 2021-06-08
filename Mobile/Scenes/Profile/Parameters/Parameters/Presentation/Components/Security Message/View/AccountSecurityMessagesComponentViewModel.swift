//
//  AccountSecurityMessagesComponentViewModel.swift
//  Mobile
//
//  Created by Irakli Shelia on 12/1/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public protocol AccountSecurityMessagesComponentViewModel: AccountSecurityMessagesComponentViewModelInput,
                                                AccountSecurityMessagesComponentViewModelOutput {}

public struct AccountSecurityMessagesComponentViewModelParams {
    let title: String
    let description: String
    let buttonTitle: String
    let switchState: Bool
}

public protocol AccountSecurityMessagesComponentViewModelInput {
    func didBind()
    func parametersSwitchToggled(to state: Bool)
}

public protocol AccountSecurityMessagesComponentViewModelOutput {
    var action: Observable<AccountSecurityMessagesComponentViewModelOutputAction> { get }
    var params: AccountSecurityMessagesComponentViewModelParams { get }
}

public enum AccountSecurityMessagesComponentViewModelOutputAction {
    case set(params: AccountSecurityMessagesComponentViewModelParams)
    case parametersSwitchToggledTo(state: Bool)
}

public class DefaultAccountSecurityMessagesComponentViewModel {
    public var params: AccountSecurityMessagesComponentViewModelParams
    private let actionSubject = PublishSubject<AccountSecurityMessagesComponentViewModelOutputAction>()
    public init(params: AccountSecurityMessagesComponentViewModelParams) {
        self.params = params
    }
}

extension DefaultAccountSecurityMessagesComponentViewModel: AccountSecurityMessagesComponentViewModel {
    public func parametersSwitchToggled(to state: Bool) {
        actionSubject.onNext(.parametersSwitchToggledTo(state: state))
    }

    public var action: Observable<AccountSecurityMessagesComponentViewModelOutputAction> {
        actionSubject.asObserver()
    }

    public func didBind() {
        actionSubject.onNext(.set(params: .init(title: params.title,
                                                description: params.description,
                                                buttonTitle: params.buttonTitle,
                                                switchState: params.switchState)))
    }
}
