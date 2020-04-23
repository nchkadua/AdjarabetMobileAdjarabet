//
//  NotificationsViewModel.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/23/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public protocol NotificationsViewModel: NotificationsViewModelInput, NotificationsViewModelOutput {
}

public struct NotificationsViewModelParams {
}

public protocol NotificationsViewModelInput {
    func viewDidLoad()
}

public protocol NotificationsViewModelOutput {
    var action: Observable<NotificationsViewModelOutputAction> { get }
    var route: Observable<NotificationsViewModelRoute> { get }
    var params: NotificationsViewModelParams { get }
}

public enum NotificationsViewModelOutputAction {
    case languageDidChange
}

public enum NotificationsViewModelRoute {
}

public class DefaultNotificationsViewModel: DefaultBaseViewModel {
    private let actionSubject = PublishSubject<NotificationsViewModelOutputAction>()
    private let routeSubject = PublishSubject<NotificationsViewModelRoute>()
    public let params: NotificationsViewModelParams

    public init(params: NotificationsViewModelParams) {
        self.params = params
    }

    public override func languageDidChange() {
        actionSubject.onNext(.languageDidChange)
    }
}

extension DefaultNotificationsViewModel: NotificationsViewModel {
    public var action: Observable<NotificationsViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<NotificationsViewModelRoute> { routeSubject.asObserver() }

    public func viewDidLoad() {
        observeLanguageChange()
    }
}
