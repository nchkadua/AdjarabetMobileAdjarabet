//
//  NotificationsHeaderComponentViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 10/15/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public protocol NotificationsHeaderComponentViewModel: NotificationsHeaderComponentViewModelInput, NotificationsHeaderComponentViewModelOutput {
}

public struct NotificationsHeaderComponentViewModelParams {
    public var title: String
}

public protocol NotificationsHeaderComponentViewModelInput {
    func didBind()
}

public protocol NotificationsHeaderComponentViewModelOutput {
    var action: Observable<NotificationsHeaderComponentViewModelOutputAction> { get }
    var params: NotificationsHeaderComponentViewModelParams { get }
}

public enum NotificationsHeaderComponentViewModelOutputAction {
    case set(title: String)
}

public class DefaultNotificationsHeaderComponentViewModel {
    public var params: NotificationsHeaderComponentViewModelParams
    private let actionSubject = PublishSubject<NotificationsHeaderComponentViewModelOutputAction>()

    public init (params: NotificationsHeaderComponentViewModelParams) {
        self.params = params
    }
}

extension DefaultNotificationsHeaderComponentViewModel: NotificationsHeaderComponentViewModel {
    public var action: Observable<NotificationsHeaderComponentViewModelOutputAction> { actionSubject.asObserver() }

    public func didBind() {
        actionSubject.onNext(.set(title: params.title))
    }
}
