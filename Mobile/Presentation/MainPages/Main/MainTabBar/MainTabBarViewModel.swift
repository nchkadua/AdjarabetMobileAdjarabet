//
//  MainTabBarViewModel.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/16/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public protocol MainTabBarViewModel: MainTabBarViewModelInput, MainTabBarViewModelOutput {
}

public protocol MainTabBarViewModelInput {
    func viewDidLoad()
    func viewWillAppear()
    func shouldSelectPage(at index: Int, currentPageIndex: Int)
}

public protocol MainTabBarViewModelOutput {
    var action: PublishSubject<MainTabBarViewModelOutputAction> { get }
    var route: PublishSubject<MainTabBarViewModelRoute> { get }
}

public enum MainTabBarViewModelOutputAction {
    case setupTabBar
    case scrollSelectedViewControllerToTop
    case selectPage(index: Int)
}

public enum MainTabBarViewModelRoute {
    case initial
}

public class DefaultMainTabBarViewModel {
    public let action = PublishSubject<MainTabBarViewModelOutputAction>()
    public let route = PublishSubject<MainTabBarViewModelRoute>()
}

extension DefaultMainTabBarViewModel: MainTabBarViewModel {
    public func viewDidLoad() {
        action.onNext(.setupTabBar)
    }

    public func viewWillAppear() {
        route.onNext(.initial)
    }

    public func shouldSelectPage(at index: Int, currentPageIndex: Int) {
        guard currentPageIndex != index else {
            action.onNext(.scrollSelectedViewControllerToTop)
            return
        }

        action.onNext(.selectPage(index: index))
    }
}
