//
//  NotVerifiedUserViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 13.09.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public protocol NotVerifiedUserViewModel: NotVerifiedUserViewModelInput, NotVerifiedUserViewModelOutput {
}

public struct NotVerifiedUserViewModelParams {
}

public protocol NotVerifiedUserViewModelInput: AnyObject {
    var params: NotVerifiedUserViewModelParams { get set }
    func viewDidLoad()
}

public protocol NotVerifiedUserViewModelOutput {
    var action: Observable<NotVerifiedUserViewModelOutputAction> { get }
    var route: Observable<NotVerifiedUserViewModelRoute> { get }
}

public enum NotVerifiedUserViewModelOutputAction {
}

public enum NotVerifiedUserViewModelRoute {
}

public class DefaultNotVerifiedUserViewModel {
    public var params: NotVerifiedUserViewModelParams
    private let actionSubject = PublishSubject<NotVerifiedUserViewModelOutputAction>()
    private let routeSubject = PublishSubject<NotVerifiedUserViewModelRoute>()

    public init(params: NotVerifiedUserViewModelParams) {
        self.params = params
    }
}

extension DefaultNotVerifiedUserViewModel: NotVerifiedUserViewModel {
    public var action: Observable<NotVerifiedUserViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<NotVerifiedUserViewModelRoute> { routeSubject.asObserver() }

    public func viewDidLoad() {
    }
}
