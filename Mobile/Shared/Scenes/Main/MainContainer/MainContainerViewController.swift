//
//  MainContainerViewController.swift
//  Mobile
//
//  Created by Nika Chkadua on 3/31/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public class MainContainerViewController: UIViewController {
    @Inject(from: .viewModels) public var viewModel: MainContainerViewModel
    public lazy var navigator = MainContainerNavigator(viewController: self)
    private let disposeBag = DisposeBag()

    private lazy var appPageViewController: ABPageViewController = ABPageViewController(viewControllers: [])
    private lazy var pageViewController: ABPageViewController = {
        return ABPageViewController(viewControllers: [navigator.mainTabBarFactory.make().wrap(in: ABNavigationController.self), navigator.profileFactory.make().wrap(in: ABNavigationController.self)])
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
        setBaseBackgorundColor()
        setupPageViewController()
    }

    private func setupPageViewController() {
        add(child: pageViewController)
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        pageViewController.view.pin(to: view)

//        appPageViewController.orderedViewControllers = [navigator.mainTabBarFactory.make().wrap(in: ABNavigationController.self), navigator.profileFactory.make().wrap(in: ABNavigationController.self)]
    }

    // MARK: Public methods
    public func jumpToMainTabBar() {
//        pageViewController.jumgToViewController(at: 0, direction: .reverse)
        pageViewController.previous()
    }

    public func jumpToProfile() {
//        pageViewController.jumgToViewController(at: 1, direction: .forward)
        pageViewController.next()
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
