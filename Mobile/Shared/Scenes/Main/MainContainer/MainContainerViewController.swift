//
//  MainContainerViewController.swift
//  Mobile
//
//  Created by Nika Chkadua on 3/31/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public class MainContainerViewController: UIViewController {
    @Inject(from: .viewModels) var viewModel: MainContainerViewModel
    lazy var navigator = MainContainerNavigator(viewController: self)
    private let disposeBag = DisposeBag()

    private lazy var appPageViewController: ABPageViewController = ABPageViewController(viewControllers: [])
    private lazy var pageViewController: ABPageViewController = {
        return ABPageViewController(viewControllers: [navigator.mainTabBarFactory.make(with: .init(homeParams: viewModel.params.homeParams)).wrap(in: ABNavigationController.self), navigator.profileFactory.make().wrap(in: ABNavigationController.self)])
    }()

    // MARK: - Lifecycle methods
    public override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }

    // MARK: Bind to viewModel's observable properties
    private func bind(to viewModel: MainContainerViewModel) {
    }

    // MARK: Setup methods
    private func setup() {
        setBaseBackgroundColor()
        setupPageViewController()
    }

    private func setupPageViewController() {
        add(child: pageViewController)
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        pageViewController.view.pin(to: view)
    }

    // MARK: Public methods
    public func jumpToMainTabBar() {
        DispatchQueue.main.async {
            self.pageViewController.previous()
        }
    }

    public func jumpToProfile() {
        DispatchQueue.main.async {
            self.pageViewController.next()
        }
    }

    public func setPageViewControllerSwipeEnabled(_ enable: Bool) {
        pageViewController.setSwipeEnabled(enable)
    }
}

extension UIViewController {
    var mainContainerViewController: MainContainerViewController? {
        return UIApplication.shared.currentWindow?.rootViewController as? MainContainerViewController
    }
}
