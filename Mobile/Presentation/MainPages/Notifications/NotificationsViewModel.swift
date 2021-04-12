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
    func viewWillAppear()
}

public protocol NotificationsViewModelOutput {
    var action: Observable<NotificationsViewModelOutputAction> { get }
    var route: Observable<NotificationsViewModelRoute> { get }
}

public enum NotificationsViewModelOutputAction {
    case initialize(AppListDataProvider)
    case didDeleteCell(atIndexPath: IndexPath)
    case setTotalItemsCount(count: Int)
    case showMessage(message: String)
}

public enum NotificationsViewModelRoute {
    case openNotificationContentPage(notification: NotificationItemsEntity.NotificationEntity)
}

public class DefaultNotificationsViewModel: DefaultBaseViewModel {
    private let actionSubject = PublishSubject<NotificationsViewModelOutputAction>()
    private let routeSubject = PublishSubject<NotificationsViewModelRoute>()

    @Inject(from: .useCases) private var notificationsUseCase: NotificationsUseCase
}

extension DefaultNotificationsViewModel: NotificationsViewModel {
    public var action: Observable<NotificationsViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<NotificationsViewModelRoute> { routeSubject.asObserver() }

    public func viewDidLoad() {}

    public func viewWillAppear() {
        var dataProvider: AppCellDataProviders = []

        notificationsUseCase.notifications(page: 1, domain: "com") { result in
            switch result {
            case .success(let notifications):
                self.dates(from: notifications).forEach {
                    let headerViewModel = DefaultNotificationsHeaderComponentViewModel(params: .init(title: $0.formattedStringValue))
                    dataProvider.append(headerViewModel)

                    for notification in notifications.elements where notification.createDate.toDateWithoutTime == $0 {
                        let model = DefaultNotificationComponentViewModel(params: .init(notification: notification))
                        model.action.subscribe(onNext: { action in
                            switch action {
                            case .didSelect(let notification): self.routeSubject.onNext(.openNotificationContentPage(notification: notification))
                            case .didDelete(let indexPath): self.actionSubject.onNext(.didDeleteCell(atIndexPath: indexPath))
                            default:
                                break
                            }
                        }).disposed(by: self.disposeBag)
                        dataProvider.append(model)
                    }
                    self.actionSubject.onNext(.setTotalItemsCount(count: notifications.totalUnreadItemsCount))
                    self.actionSubject.onNext(.initialize(dataProvider.makeList()))
                }
            case .failure(let error): self.actionSubject.onNext(.showMessage(message: error.localizedDescription))
            }
        }
    }

    private func dates(from notifications: NotificationItemsEntity) -> [Date] {
        return notifications.elements.map({ (notification: NotificationItemsEntity.NotificationEntity) -> Date in notification.createDate.toDateWithoutTime}).uniques
    }
}
