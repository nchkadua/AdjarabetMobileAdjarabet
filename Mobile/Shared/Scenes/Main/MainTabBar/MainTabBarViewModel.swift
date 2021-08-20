//
//  MainTabBarViewModel.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/16/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

protocol MainTabBarViewModel: MainTabBarViewModelInput, MainTabBarViewModelOutput {
}

struct MainTabBarViewModelParams {
    let homeParams: HomeViewModelParams
    init(homeParams: HomeViewModelParams = .init()) {
        self.homeParams = homeParams
    }
}

protocol MainTabBarViewModelInput {
    func viewDidLoad()
    func viewWillAppear()
    func shouldSelectPage(at index: Int, currentPageIndex: Int)
}

protocol MainTabBarViewModelOutput {
    var params: MainTabBarViewModelParams { get set }
    var action: PublishSubject<MainTabBarViewModelOutputAction> { get }
    var route: PublishSubject<MainTabBarViewModelRoute> { get }
}

enum MainTabBarViewModelOutputAction {
    case setupTabBar
    case scrollSelectedViewControllerToTop
    case selectPage(index: Int)
}

enum MainTabBarViewModelRoute {
    case initial
}

class DefaultMainTabBarViewModel {
    var params: MainTabBarViewModelParams = .init()
    let action = PublishSubject<MainTabBarViewModelOutputAction>()
    let route = PublishSubject<MainTabBarViewModelRoute>()
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
