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
    private lazy var appTableViewController = ABTableViewController()

    // MARK: Overrides
    public override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    public override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        bind(to: viewModel)
        viewModel.viewDidLoad()
        generateAccessibilityIdentifiers()
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mainTabBarViewController?.showFloatingTabBar()
        setMainContainerSwipeEnabled(false)
    }

    private func setup() {
        setBaseBackgorundColor(to: .primaryBg())
        setupNavigationItems()
        setupTableView()
    }

    private func setupNavigationItems() {
        setNotificationsBarButton()

        let settingsButton = makeSettingsBarButtonItem()
        navigationItem.rightBarButtonItem = settingsButton
    }

    private func setNotificationsBarButton() {
        navigationItem.leftBarButtonItems = notificationsBarButtonItemGroupWith(numberOfNotifications: NotificationsProvider.unreadNotifications().count)
    }

    private func setupTableView() {
        add(child: appTableViewController)
        appTableViewController.view.translatesAutoresizingMaskIntoConstraints = false
        appTableViewController.view.pin(to: view)

        appTableViewController.isTabBarManagementEnabled = true
        appTableViewController.canEditRow = true
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
        case .initialize(let appListDataProvider): appTableViewController.dataProvider = appListDataProvider
        case .didDeleteCell(let indexPath): deleteCell(at: indexPath)
        }
    }

    private func didRecive(route: NotificationsViewModelRoute) {
        switch route {
        case .openNotificationContentPage(let notification): openNotificationContentPage(with: notification)
        }
    }

    // MARK: Action methods
    private func deleteCell(at indexPath: IndexPath) {
        NotificationsProvider.delete(at: indexPath.section)
        appTableViewController.reloadItems(deletionIndexPathes: [indexPath])
        setNotificationsBarButton()
    }

    private func openNotificationContentPage(with notification: Notification) {
        mainTabBarViewController?.hideFloatingTabBar()
        navigator.navigate(to: .notificationContentPage(params: .init(notification: notification)), animated: true)
    }
}

extension NotificationsViewController: CommonBarButtonProviding { }

extension NotificationsViewController: Accessible {}
