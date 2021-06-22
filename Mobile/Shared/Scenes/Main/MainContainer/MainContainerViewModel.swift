//
//  MainContainerViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 3/31/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public protocol MainContainerViewModel: MainContainerViewModelInput, MainContainerViewModelOutput {
}

public struct MainContainerViewModelParams {
}

public protocol MainContainerViewModelInput: AnyObject {
    var params: MainContainerViewModelParams { get set }
    func viewDidLoad()
}

public protocol MainContainerViewModelOutput {
    var action: Observable<MainContainerViewModelOutputAction> { get }
    var route: Observable<MainContainerViewModelRoute> { get }
}

public enum MainContainerViewModelOutputAction {
}

public enum MainContainerViewModelRoute {
}

public class DefaultMainContainerViewModel {
    public var params: MainContainerViewModelParams
    private let actionSubject = PublishSubject<MainContainerViewModelOutputAction>()
    private let routeSubject = PublishSubject<MainContainerViewModelRoute>()

    public init(params: MainContainerViewModelParams) {
        self.params = params
    }
}

extension DefaultMainContainerViewModel: MainContainerViewModel {
    public var action: Observable<MainContainerViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<MainContainerViewModelRoute> { routeSubject.asObserver() }

    public func viewDidLoad() {
    }
}
