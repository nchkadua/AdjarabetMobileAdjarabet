//
//  NewPasswordViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 30.06.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public protocol NewPasswordViewModel: NewPasswordViewModelInput, NewPasswordViewModelOutput {
}

public struct NewPasswordViewModelParams {
}

public protocol NewPasswordViewModelInput: AnyObject {
    var params: NewPasswordViewModelParams { get set }
    func viewDidLoad()
}

public protocol NewPasswordViewModelOutput {
    var action: Observable<NewPasswordViewModelOutputAction> { get }
    var route: Observable<NewPasswordViewModelRoute> { get }
}

public enum NewPasswordViewModelOutputAction {
}

public enum NewPasswordViewModelRoute {
}

public class DefaultNewPasswordViewModel {
    public var params: NewPasswordViewModelParams
    private let actionSubject = PublishSubject<NewPasswordViewModelOutputAction>()
    private let routeSubject = PublishSubject<NewPasswordViewModelRoute>()

    public init(params: NewPasswordViewModelParams) {
        self.params = params
    }
}

extension DefaultNewPasswordViewModel: NewPasswordViewModel {
    public var action: Observable<NewPasswordViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<NewPasswordViewModelRoute> { routeSubject.asObserver() }

    public func viewDidLoad() {
    }
}
