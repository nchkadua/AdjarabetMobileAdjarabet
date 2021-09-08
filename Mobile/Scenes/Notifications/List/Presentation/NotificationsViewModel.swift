//
//  NotificationsViewModel.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/23/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

protocol NotificationsViewModel: BaseViewModel, NotificationsViewModelInput, NotificationsViewModelOutput, ABTableViewControllerDelegate, AppRedrawableCellDelegate {
}

public protocol NotificationsViewModelInput {
    func viewDidLoad()
    var emptyStateViewModel: EmptyStateComponentViewModel { get }
}

public protocol NotificationsViewModelOutput {
    var action: Observable<NotificationsViewModelOutputAction> { get }
    var route: Observable<NotificationsViewModelRoute> { get }
}

public enum NotificationsViewModelOutputAction {
    case didDeleteCell(atIndexPath: IndexPath)
    case didLoadingFinished
    case initialize(AppListDataProvider)
    case reload(atIndexPath: IndexPath)
    case reloadItems(items: AppCellDataProviders, insertionIndexPathes: [IndexPath], deletionIndexPathes: [IndexPath])
    case setTotalItemsCount(count: Int)
    case isLoading(loading: Bool)
}

public enum NotificationsViewModelRoute {
    case openNotificationContentPage(notification: NotificationItemsEntity.NotificationEntity)
}

public class DefaultNotificationsViewModel: DefaultBaseViewModel {
    private let actionSubject = PublishSubject<NotificationsViewModelOutputAction>()
    private let routeSubject = PublishSubject<NotificationsViewModelRoute>()
    public lazy var emptyStateViewModel: EmptyStateComponentViewModel = DefaultEmptyStateComponentViewModel(params: .init(
                                            icon: R.image.notifications.empty_state_icon()!,
                                            title: R.string.localization.notifications_empty_state_title(),
                                            description: R.string.localization.notifications_empty_state_description()))

    @Inject(from: .useCases) private var notificationsUseCase: NotificationsUseCase
    private var notificationsDataProvider: AppCellDataProviders = []
    private var page: PageDescription = .init()
    private var numberOfUnreadNotifications = -1

    public let loading = DefaultLoadingComponentViewModel(params: .init(tintColor: .secondaryText(), height: 55))
    private var loadingType: LoadingType = .none {
        didSet {
            guard loadingType != oldValue else { return }
            let isNextPage = loadingType == .nextPage
            loading.set(isLoading: isNextPage)
        }
    }
    private var lastSelectedIndexPath: IndexPath?
}

extension DefaultNotificationsViewModel: NotificationsViewModel {
    public var action: Observable<NotificationsViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<NotificationsViewModelRoute> { routeSubject.asObserver() }

    private func load(loadingType: LoadingType) {
        actionSubject.onNext(.isLoading(loading: true))
        self.loadingType = loadingType
        notificationsUseCase.notifications(page: page.current, domain: "com") { result in //TODO: dynamic domain
            defer {
                self.loadingType = .none
                self.actionSubject.onNext(.didLoadingFinished)
                self.actionSubject.onNext(.isLoading(loading: false))
            }

            switch result {
            case .success(let notifications):
                self.page.itemsPerPage = notifications.itemsPerPage
                self.createModelsFrom(notifications: notifications)
            case .failure(let error):
                self.show(error: error)
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
                subscribeTo(notification: model, notification: notification)
                dataProvider.append(model)
            }

            // TotalNumberOfUnreadNotifications is not updated after firs page, so needs to be saved (Backend bug)
            if numberOfUnreadNotifications == -1 {
                numberOfUnreadNotifications = notifications.totalUnreadItemsCount
            }
            self.actionSubject.onNext(.setTotalItemsCount(count: numberOfUnreadNotifications))
        }
        self.appendPage(notifications: dataProvider)
    }

    private func subscribeTo(notification model: DefaultNotificationComponentViewModel, notification: NotificationItemsEntity.NotificationEntity) {
        model.action.subscribe(onNext: { action in
            switch action {
            case .didSelect(let notification):
                self.routeSubject.onNext(.openNotificationContentPage(notification: notification))
                self.decreaseNumberOfUnreads(notification: notification)
            case .didDelete(let indexPath): self.delete(notification: notification, at: indexPath)
            default:
                break
            }
        }).disposed(by: self.disposeBag)
    }

    private func dates(from notifications: NotificationItemsEntity) -> [Date] {
        return notifications.elements.map({ (notification: NotificationItemsEntity.NotificationEntity) -> Date in notification.createDate.toDateWithoutTime}).uniques
    }

    private func delete(notification: NotificationItemsEntity.NotificationEntity, at indexPath: IndexPath) {
        notificationsUseCase.delete(notificationId: notification.id, handler: handler(onSuccessHandler: { _ in
            self.notificationsDataProvider.remove(at: indexPath.row)
            self.actionSubject.onNext(.didDeleteCell(atIndexPath: indexPath))
            self.decreaseNumberOfUnreads(notification: notification)
        }))
    }

    private func decreaseNumberOfUnreads(notification: NotificationItemsEntity.NotificationEntity) {
        guard notification.status == NotificationStatus.unread.rawValue else { return }

        self.numberOfUnreadNotifications -= 1
        self.actionSubject.onNext(.setTotalItemsCount(count: self.numberOfUnreadNotifications))
    }

    private func appendPage(notifications: AppCellDataProviders) {
        let offset = self.notificationsDataProvider.count
        self.page.setNextPage()
        self.page.configureHasMore(forNumberOfItems: notifications.count)

        notificationsDataProvider.append(contentsOf: notifications)
        let indexPathes = notifications.enumerated().map { IndexPath(item: offset + $0.offset, section: 0) }
        actionSubject.onNext(.reloadItems(items: notifications, insertionIndexPathes: indexPathes, deletionIndexPathes: []))
    }

    public func viewDidLoad() {
        displayEmptyNotificationList()
        load(loadingType: .fullScreen)
    }

    private func displayEmptyNotificationList() {
        self.resetPaging()
        let initialEmptyDataProvider: AppCellDataProviders = []
        self.actionSubject.onNext(.initialize(initialEmptyDataProvider.makeList()))
    }

    private func resetPaging() {
        self.notificationsDataProvider = []
        page.reset()
        page.current = 1
    }

    public func didDeleteCell(at indexPath: IndexPath) {}

    public func didLoadNextPage() {
        guard page.hasMore else { return }
        load(loadingType: .nextPage)
    }

    public func redraw(at indexPath: IndexPath) {
        actionSubject.onNext(.reload(atIndexPath: indexPath))
    }
}
