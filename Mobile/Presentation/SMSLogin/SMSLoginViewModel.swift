//
//  SMSLoginViewModel.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 5/13/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public protocol SMSLoginViewModel: SMSLoginViewModelInput, SMSLoginViewModelOutput {
}

public struct SMSLoginViewModelParams {
}

public protocol SMSLoginViewModelInput {
    func viewDidLoad()
}

public protocol SMSLoginViewModelOutput {
    var action: Observable<SMSLoginViewModelOutputAction> { get }
    var route: Observable<SMSLoginViewModelRoute> { get }
    var params: SMSLoginViewModelParams { get }
}

public enum SMSLoginViewModelOutputAction {
}

public enum SMSLoginViewModelRoute {
}

public class DefaultSMSLoginViewModel {
    private let actionSubject = PublishSubject<SMSLoginViewModelOutputAction>()
    private let routeSubject = PublishSubject<SMSLoginViewModelRoute>()
    public let params: SMSLoginViewModelParams

    public init(params: SMSLoginViewModelParams) {
        self.params = params
    }
}

extension DefaultSMSLoginViewModel: SMSLoginViewModel {
    public var action: Observable<SMSLoginViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<SMSLoginViewModelRoute> { routeSubject.asObserver() }

    public func viewDidLoad() {
    }
}
