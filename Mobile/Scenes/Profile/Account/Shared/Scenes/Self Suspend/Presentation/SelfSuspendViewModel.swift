//
//  SelfSuspendViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 11/24/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

protocol SelfSuspendViewModel: BaseViewModel, SelfSuspendViewModelInput, SelfSuspendViewModelOutput {
}

public protocol SelfSuspendViewModelInput {
    func viewDidLoad()
}

public protocol SelfSuspendViewModelOutput {
    var action: Observable<SelfSuspendViewModelOutputAction> { get }
    var route: Observable<SelfSuspendViewModelRoute> { get }
}

public enum SelfSuspendViewModelOutputAction {
    case setupDurations(durations: [String])
}

public enum SelfSuspendViewModelRoute {
}

public class DefaultSelfSuspendViewModel: DefaultBaseViewModel {
    private let actionSubject = PublishSubject<SelfSuspendViewModelOutputAction>()
    private let routeSubject = PublishSubject<SelfSuspendViewModelRoute>()
}

extension DefaultSelfSuspendViewModel: SelfSuspendViewModel {
    public var action: Observable<SelfSuspendViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<SelfSuspendViewModelRoute> { routeSubject.asObserver() }

    public func viewDidLoad() {
        actionSubject.onNext(.setupDurations(durations: DurationProvider.durations()))
    }
}
