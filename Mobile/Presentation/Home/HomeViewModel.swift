//
//  HomeViewModel.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/23/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public protocol HomeViewModel: HomeViewModelInput, HomeViewModelOutput {
}

public struct HomeViewModelParams {
}

public protocol HomeViewModelInput {
    func viewDidLoad()
}

public protocol HomeViewModelOutput {
    var action: Observable<HomeViewModelOutputAction> { get }
    var route: Observable<HomeViewModelRoute> { get }
    var params: HomeViewModelParams { get }
}

public enum HomeViewModelOutputAction {
    case languageDidChange
}

public enum HomeViewModelRoute {
}

public class DefaultHomeViewModel: DefaultBaseViewModel {
    private let actionSubject = PublishSubject<HomeViewModelOutputAction>()
    private let routeSubject = PublishSubject<HomeViewModelRoute>()
    public let params: HomeViewModelParams

    public init(params: HomeViewModelParams) {
        self.params = params
    }

    public override func languageDidChange() {
        actionSubject.onNext(.languageDidChange)
    }
}

extension DefaultHomeViewModel: HomeViewModel {
    public var action: Observable<HomeViewModelOutputAction> { actionSubject.asObserver() }

    public var route: Observable<HomeViewModelRoute> { routeSubject.asObserver() }

    public func viewDidLoad() {
        observeLanguageChange()
    }
}
