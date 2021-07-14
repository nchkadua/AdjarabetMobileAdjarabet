//
//  ResetOptionComponentViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 14.07.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public protocol ResetOptionComponentViewModel: ResetOptionComponentViewModelInput,
                                                ResetOptionComponentViewModelOutput {}

public struct ResetOptionComponentViewModelParams {
    let title: String
    let roundCorners: UIRectCorner
    let hidesSeparator: Bool
    let isDisabled: Bool
}

public protocol ResetOptionComponentViewModelInput {
    func didBind()
    func didSelect(at indexPath: IndexPath)
}

public protocol ResetOptionComponentViewModelOutput {
    var action: Observable<ResetOptionComponentViewModelOutputAction> { get }
    var params: ResetOptionComponentViewModelParams { get }
}

public enum ResetOptionComponentViewModelOutputAction {
    case setupUI(title: String?, roundCorners: UIRectCorner, hidesSeparator: Bool, isDisabled: Bool)
    case didSelect(indexPath: IndexPath)
}

public class DefaultResetOptionComponentViewModel {
    public var params: ResetOptionComponentViewModelParams
    private let actionSubject = PublishSubject<ResetOptionComponentViewModelOutputAction>()
    public init(params: ResetOptionComponentViewModelParams) {
        self.params = params
    }
}

extension DefaultResetOptionComponentViewModel: ResetOptionComponentViewModel {
    public var action: Observable<ResetOptionComponentViewModelOutputAction> {
        actionSubject.asObserver()
    }

    public func didBind() {
        actionSubject.onNext(.setupUI(title: params.title, roundCorners: params.roundCorners, hidesSeparator: params.hidesSeparator, isDisabled: params.isDisabled))
    }

    public func didSelect(at indexPath: IndexPath) {
        actionSubject.onNext(.didSelect(indexPath: indexPath))
    }
}
