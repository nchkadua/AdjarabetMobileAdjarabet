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

public protocol NotificationsViewModelInput {
    func viewDidLoad()
}

public protocol NotificationsViewModelOutput {
    var action: Observable<NotificationsViewModelOutputAction> { get }
    var route: Observable<NotificationsViewModelRoute> { get }
}

public enum NotificationsViewModelOutputAction {
    case initialize(AppListDataProvider)
    case didDeleteCell(atIndexPath: IndexPath)
}

public enum NotificationsViewModelRoute {
    case openNotificationContentPage(notification: Notification)
}

public class DefaultNotificationsViewModel: DefaultBaseViewModel {
    private let actionSubject = PublishSubject<NotificationsViewModelOutputAction>()
    private let routeSubject = PublishSubject<NotificationsViewModelRoute>()
}

extension DefaultNotificationsViewModel: NotificationsViewModel {
    public var action: Observable<NotificationsViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<NotificationsViewModelRoute> { routeSubject.asObserver() }

    public func viewDidLoad() {
        var dataProvider: AppCellDataProviders = []

        NotificationsProvider.dates().forEach {
            let headerModel = DefaultNotificationsHeaderComponentViewModel(params: NotificationsHeaderComponentViewModelParams(title: $0.stringValue))
            dataProvider.append(headerModel)

            NotificationsProvider.notifications(ofDate: $0).forEach {
                let model = DefaultNotificationComponentViewModel(params: NotificationComponentViewModelParams(notification: $0))
                model.action.subscribe(onNext: { action in
                    switch action {
                    case .didSelect(let notification): self.routeSubject.onNext(.openNotificationContentPage(notification: notification))
                    case .didDelete(let indexPath): self.actionSubject.onNext(.didDeleteCell(atIndexPath: indexPath))
                    default:
                        break
                    }
                }).disposed(by: disposeBag)
                dataProvider.append(model)
            }
        }
        actionSubject.onNext(.initialize(dataProvider.makeList()))
    }
}
