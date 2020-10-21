//
//  QuickActionComponentViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/6/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public protocol QuickActionComponentViewModel: QuickActionComponentViewModelInput, QuickActionComponentViewModelOutput {
}

public struct QuickActionComponentViewModelParams {
    public var icon: UIImage
    public var title: String
    public var hidesSeparator: Bool
    public var destination: ProfileNavigator.Destination
}

public protocol QuickActionComponentViewModelInput {
    func didBind()
    func didSelect(at indexPath: IndexPath)
}

public protocol QuickActionComponentViewModelOutput {
    var action: Observable<QuickActionComponentViewModelOutputAction> { get }
    var params: QuickActionComponentViewModelParams { get }
}

public enum QuickActionComponentViewModelOutputAction {
    case set(icon: UIImage, title: String, hideSeparator: Bool)
    case didSelect(indexPath: IndexPath)
}

public class DefaultQuickActionComponentViewModel {
    public var params: QuickActionComponentViewModelParams
    private let actionSubject = PublishSubject<QuickActionComponentViewModelOutputAction>()

    public init (params: QuickActionComponentViewModelParams) {
        self.params = params
    }
}

extension DefaultQuickActionComponentViewModel: QuickActionComponentViewModel {
    public var action: Observable<QuickActionComponentViewModelOutputAction> { actionSubject.asObserver() }

    public func didBind() {
        actionSubject.onNext(.set(icon: params.icon, title: params.title, hideSeparator: params.hidesSeparator))
    }

    public func didSelect(at indexPath: IndexPath) {
        actionSubject.onNext(.didSelect(indexPath: indexPath))
    }
}
