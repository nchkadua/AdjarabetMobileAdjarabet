//
//  NotificationsViewController.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/14/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public class NotificationsViewController: ABViewController {
    // MARK: Properties
    @Inject(from: .viewModels) private var viewModel: NotificationsViewModel
    public lazy var navigator = NotificationsNavigator(viewController: self)
    private lazy var appTableViewController = ABTableViewController().configureEmptyState(with: viewModel.emptyStateViewModel)

    // MARK: Overrides
    public override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    public override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        bind(to: viewModel)
        errorThrowing = viewModel
        viewModel.viewDidLoad()
    }

    private func setup() {
        setBaseBackgroundColor(to: .primaryBg())
        setupNavigationItems()
        setupTableView()
    }

    private func setupNavigationItems() {
        let settingsButton = makeSettingsBarButtonItem()
        navigationItem.rightBarButtonItem = settingsButton
    }

    private func setTotalNumberOfUnreadNotifications(_ numberOfItems: Int) {
        navigationItem.leftBarButtonItems = notificationsBarButtonItemGroupWith(numberOfNotifications: numberOfItems)
    }

    private func setupTableView() {
        add(child: appTableViewController)
        appTableViewController.view.translatesAutoresizingMaskIntoConstraints = false
        appTableViewController.view.pin(to: view)

        appTableViewController.isTabBarManagementEnabled = true
        appTableViewController.canEditRow = true
        appTableViewController.delegate = viewModel
    }

    private func bind(to viewModel: NotificationsViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didReceive(action: action)
        }).disposed(by: disposeBag)

        viewModel.route.subscribe(onNext: { [weak self] route in
            self?.didRecive(route: route)
        }).disposed(by: disposeBag)
    }

    private func didReceive(action: NotificationsViewModelOutputAction) {
        switch action {
        case .didDeleteCell(let indexPath): deleteCell(at: indexPath)
        case .didLoadingFinished: appTableViewController.enableEmptyState()
        case .initialize(let appListDataProvider): appTableViewController.dataProvider = appListDataProvider
        case .reloadItems(let items, let insertions, let deletions):
            UIView.performWithoutAnimation {
                appTableViewController.reloadItems(items: items, insertionIndexPathes: insertions, deletionIndexPathes: deletions)
            }
        case .setTotalItemsCount(let count): setTotalNumberOfUnreadNotifications(count)
        default:
            break
        }
    }

    private func didRecive(route: NotificationsViewModelRoute) {
        switch route {
        case .openNotificationContentPage(let notification): openNotificationContentPage(with: notification)
        }
    }

    // MARK: Action methods
    private func deleteCell(at indexPath: IndexPath) {
        appTableViewController.reloadItems(deletionIndexPathes: [indexPath])
//        viewModel.viewWillAppear()
    }

    private func openNotificationContentPage(with notification: NotificationItemsEntity.NotificationEntity) {
        navigator.navigate(to: .notificationContentPage(params: .init(notification: notification)), animated: true)
    }
}

extension NotificationsViewController: CommonBarButtonProviding { }
