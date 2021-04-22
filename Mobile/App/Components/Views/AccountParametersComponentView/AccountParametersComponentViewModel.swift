//
//  AccountParametersComponentViewModel.swift
//  Mobile
//
//  Created by Irakli Shelia on 12/1/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public protocol AccountParametersComponentViewModel: AccountParametersComponentViewModelInput,
                                                AccountParametersComponentViewModelOutput {}

public struct AccountParametersComponentViewModelParams {
    let title: String
    let icon: UIImage
    let corners: UIRectCorner
    let hideSeparator: Bool
}

public protocol AccountParametersComponentViewModelInput {
    func didBind()
}

public protocol AccountParametersComponentViewModelOutput {
    var action: Observable<AccountParametersComponentViewModelOutputAction> { get }
    var params: AccountParametersComponentViewModelParams { get }
}

public enum AccountParametersComponentViewModelOutputAction {
    case set(params: AccountParametersComponentViewModelParams)
    case didSelect(indexPath: IndexPath)
}

public class DefaultAccountParametersComponentViewModel {
    public var params: AccountParametersComponentViewModelParams
    private let actionSubject = PublishSubject<AccountParametersComponentViewModelOutputAction>()
    public init(params: AccountParametersComponentViewModelParams) {
        self.params = params
    }
}

extension DefaultAccountParametersComponentViewModel: AccountParametersComponentViewModel {
    public func didSelect(at indexPath: IndexPath) {
        actionSubject.onNext(.didSelect(indexPath: indexPath))
    }

    public var action: Observable<AccountParametersComponentViewModelOutputAction> {
        actionSubject.asObserver()
    }

    public func didBind() {
        actionSubject.onNext(.set(params: params))
    }
}
