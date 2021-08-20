//
//  MainContainerViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 3/31/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

protocol MainContainerViewModel: MainContainerViewModelInput, MainContainerViewModelOutput {}

struct MainContainerViewModelParams {
    let homeParams: HomeViewModelParams
    init(homeParams: HomeViewModelParams = .init()) {
        self.homeParams = homeParams
    }
}

protocol MainContainerViewModelInput: AnyObject {
    var params: MainContainerViewModelParams { get set }
    func viewDidLoad()
}

protocol MainContainerViewModelOutput {
    var action: Observable<MainContainerViewModelOutputAction> { get }
    var route: Observable<MainContainerViewModelRoute> { get }
}

enum MainContainerViewModelOutputAction {}

enum MainContainerViewModelRoute {}

class DefaultMainContainerViewModel {
    var params: MainContainerViewModelParams = .init()
    private let actionSubject = PublishSubject<MainContainerViewModelOutputAction>()
    private let routeSubject = PublishSubject<MainContainerViewModelRoute>()
}

extension DefaultMainContainerViewModel: MainContainerViewModel {
    var action: Observable<MainContainerViewModelOutputAction> { actionSubject.asObserver() }
    var route: Observable<MainContainerViewModelRoute> { routeSubject.asObserver() }

    func viewDidLoad() {}
}
