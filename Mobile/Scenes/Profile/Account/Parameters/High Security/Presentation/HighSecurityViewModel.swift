//
//  HighSecurityViewModel.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 6/25/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public protocol HighSecurityViewModel: HighSecurityViewModelInput, HighSecurityViewModelOutput {
}

public struct HighSecurityViewModelParams {
}

public protocol HighSecurityViewModelInput: AnyObject {
    var params: HighSecurityViewModelParams { get set }
    func viewDidLoad()
}

public protocol HighSecurityViewModelOutput {
    var action: Observable<HighSecurityViewModelOutputAction> { get }
    var route: Observable<HighSecurityViewModelRoute> { get }
}

public enum HighSecurityViewModelOutputAction {
}

public enum HighSecurityViewModelRoute {
}

public class DefaultHighSecurityViewModel {
    public var params: HighSecurityViewModelParams
    private let actionSubject = PublishSubject<HighSecurityViewModelOutputAction>()
    private let routeSubject = PublishSubject<HighSecurityViewModelRoute>()

    public init(params: HighSecurityViewModelParams) {
        self.params = params
    }
}

extension DefaultHighSecurityViewModel: HighSecurityViewModel {
    public var action: Observable<HighSecurityViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<HighSecurityViewModelRoute> { routeSubject.asObserver() }

    public func viewDidLoad() {
    }
}
