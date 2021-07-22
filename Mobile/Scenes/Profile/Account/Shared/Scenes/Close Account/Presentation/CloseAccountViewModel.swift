//
//  CloseAccountViewModel.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 7/21/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public protocol CloseAccountViewModel: CloseAccountViewModelInput, CloseAccountViewModelOutput {
}

public struct CloseAccountViewModelParams {
}

public protocol CloseAccountViewModelInput: AnyObject {
    var params: CloseAccountViewModelParams { get set }
    func viewDidLoad()
}

public protocol CloseAccountViewModelOutput {
    var action: Observable<CloseAccountViewModelOutputAction> { get }
    var route: Observable<CloseAccountViewModelRoute> { get }
}

public enum CloseAccountViewModelOutputAction {
}

public enum CloseAccountViewModelRoute {
}

public class DefaultCloseAccountViewModel {
    public var params: CloseAccountViewModelParams
    private let actionSubject = PublishSubject<CloseAccountViewModelOutputAction>()
    private let routeSubject = PublishSubject<CloseAccountViewModelRoute>()

    public init(params: CloseAccountViewModelParams) {
        self.params = params
    }
}

extension DefaultCloseAccountViewModel: CloseAccountViewModel {
    public var action: Observable<CloseAccountViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<CloseAccountViewModelRoute> { routeSubject.asObserver() }

    public func viewDidLoad() {
    }
}
