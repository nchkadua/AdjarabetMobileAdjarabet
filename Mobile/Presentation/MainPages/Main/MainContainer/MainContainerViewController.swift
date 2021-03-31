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
    private lazy var mainWindowVC: MainContainerViewController? = {
        return UIApplication.shared.currentWindow?.rootViewController as? MainContainerViewController
    }()

    private lazy var appPageViewController: ABPageViewController = ABPageViewController(transitionStyle: .scroll)

    // MARK: - Lifecycle methods
    public override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        bind(to: viewModel)
        viewModel.viewDidLoad()
    }

    // MARK: Bind to viewModel's observable properties
    private func bind(to viewModel: MainContainerViewModel) {
        viewModel.action.subscribe(onNext: { [weak self] action in
            self?.didRecive(action: action)
        }).disposed(by: disposeBag)
    }

    private func didRecive(action: MainContainerViewModelOutputAction) {
    }

    // MARK: Setup methods
    private func setup() {
        setBaseBackgorundColor()
        setupPageViewController()
    }

    private func setupPageViewController() {
        add(child: appPageViewController)
        appPageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        appPageViewController.view.pin(to: view)

        appPageViewController.orderedViewControllers = [navigator.mainTabBarFactory.make().wrap(in: ABNavigationController.self), navigator.profileFactory.make().wrap(in: ABNavigationController.self)]
    }

    // MARK: Public methods
    public func jumpToMainTabBar() {
        appPageViewController.jumgToViewController(at: 0, direction: .reverse)
    }

    public func jumpToProfile() {
        appPageViewController.jumgToViewController(at: 1, direction: .forward)
    }

    public func setPageViewControllerSwipeEnabled(_ enable: Bool) {
        appPageViewController.setSwipeEnabled(enable)
    }
}
