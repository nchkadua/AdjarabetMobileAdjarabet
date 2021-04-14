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
    func viewWillDissapear()
}

public protocol NotificationsViewModelOutput {
    var action: Observable<NotificationsViewModelOutputAction> { get }
    var route: Observable<NotificationsViewModelRoute> { get }
}

public enum NotificationsViewModelOutputAction {
    case initialize(AppListDataProvider)
    case reloadItems(items: AppCellDataProviders, insertionIndexPathes: [IndexPath], deletionIndexPathes: [IndexPath])
    case reloadData
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
    private var notificationsDataProvider: AppCellDataProviders = []
    private var notificationsArray: NotificationItemsEntity = NotificationItemsEntity(elements: [], totalItemsCount: 0, totalUnreadItemsCount: 0, pageCount: 0, itemsPerPage: 0)
    private var page: PageDescription = .init()
}

extension DefaultNotificationsViewModel: NotificationsViewModel {
    public var action: Observable<NotificationsViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<NotificationsViewModelRoute> { routeSubject.asObserver() }

    public func viewDidLoad() {
        displayEmptyNotificationList()
        load(page: self.page.current)
    }

    public func viewWillDissapear() {
        resetPaging()
    }

    private func displayEmptyNotificationList() {
        self.resetPaging()
        let initialEmptyDataProvider: AppCellDataProviders = []
        self.actionSubject.onNext(.initialize(initialEmptyDataProvider.makeList()))
    }

    private func load(page: Int) {
        notificationsUseCase.notifications(page: page, domain: "com") { result in //TODO: dynamic domain
            switch result {
            case .success(let notifications):
                self.notificationsArray = NotificationItemsEntity(elements: notifications.elements.map { $0 }, totalItemsCount: notifications.totalItemsCount, totalUnreadItemsCount: notifications.totalUnreadItemsCount, pageCount: notifications.pageCount, itemsPerPage: notifications.itemsPerPage)

                self.page.itemsPerPage = notifications.itemsPerPage
                self.createModelsFrom(notifications: self.notificationsArray)
            case .failure(let error): self.actionSubject.onNext(.showMessage(message: error.localizedDescription))
            }
        }
    }

    private func createModelsFrom(notifications: NotificationItemsEntity) {
        var dataProvider: AppCellDataProviders = []
        self.dates(from: notifications).forEach {
            let headerViewModel = DefaultNotificationsHeaderComponentViewModel(params: .init(title: $0.formattedStringValue))
            dataProvider.append(headerViewModel)

            for notification in notifications.elements where notification.createDate.toDateWithoutTime == $0 {
                let model = DefaultNotificationComponentViewModel(params: .init(notification: notification))
                model.action.subscribe(onNext: { action in
                    switch action {
                    case .didSelect(let notification): self.routeSubject.onNext(.openNotificationContentPage(notification: notification))
                    case .didDelete(let indexPath): self.delete(notification: notification, at: indexPath)
                    default:
                        break
                    }
                }).disposed(by: self.disposeBag)
                dataProvider.append(model)
            }
            self.actionSubject.onNext(.setTotalItemsCount(count: notifications.totalUnreadItemsCount))
        }
        self.appendPage(notifications: dataProvider)
    }

    private func appendPage(notifications: AppCellDataProviders) {
        let offset = self.notificationsDataProvider.count
        self.page.setNextPage()
        self.page.configureHasMore(forNumberOfItems: notifications.count)

        notificationsDataProvider.append(contentsOf: notifications)

        let indexPathes = notifications.enumerated().map { IndexPath(item: offset + $0.offset, section: 0) }
        actionSubject.onNext(.reloadItems(items: notifications, insertionIndexPathes: indexPathes, deletionIndexPathes: []))
    }

    private func dates(from notifications: NotificationItemsEntity) -> [Date] {
        return notifications.elements.map({ (notification: NotificationItemsEntity.NotificationEntity) -> Date in notification.createDate.toDateWithoutTime}).uniques
    }

    private func delete(notification: NotificationItemsEntity.NotificationEntity, at indexPath: IndexPath) {
//        self.actionSubject.onNext(.didDeleteCell(atIndexPath: indexPath))
//        self.resetPaging()
////                self.load(page: self.page.current)
//        self.dates(from: self.notificationsArray).forEach {
//            print("Asdadsads ", $0.formattedStringValue)
//        }
//        self.notificationsArray.elements.remove(at: indexPath.section)
//        self.dates(from: self.notificationsArray).forEach {
//            print("Asdadsads ", $0.formattedStringValue)
//        }
//        self.createModelsFrom(notifications: self.notificationsArray)
//
//        return
        notificationsUseCase.delete(notificationId: notification.id) { result in
            switch result {
            case .success:
                self.actionSubject.onNext(.didDeleteCell(atIndexPath: indexPath))
//                self.resetPaging()
//                self.load(page: self.page.current)
            case .failure(let error): self.actionSubject.onNext(.showMessage(message: error.localizedDescription))
            }
        }
    }

    private func resetPaging() {
        self.notificationsDataProvider = []
        page.reset()
        page.current = 0
    }
}
