//
//  PhoneVerificationViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 30.06.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import RxSwift

public protocol PhoneVerificationViewModel: PhoneVerificationViewModelInput, PhoneVerificationViewModelOutput {
}

public struct PhoneVerificationViewModelParams {
}

public protocol PhoneVerificationViewModelInput: AnyObject {
    var params: PhoneVerificationViewModelParams { get set }
    func viewDidLoad()
}

public protocol PhoneVerificationViewModelOutput {
    var action: Observable<PhoneVerificationViewModelOutputAction> { get }
    var route: Observable<PhoneVerificationViewModelRoute> { get }
}

public enum PhoneVerificationViewModelOutputAction {
}

public enum PhoneVerificationViewModelRoute {
}

public class DefaultPhoneVerificationViewModel {
    public var params: PhoneVerificationViewModelParams
    private let actionSubject = PublishSubject<PhoneVerificationViewModelOutputAction>()
    private let routeSubject = PublishSubject<PhoneVerificationViewModelRoute>()

    public init(params: PhoneVerificationViewModelParams) {
        self.params = params
    }
}

extension DefaultPhoneVerificationViewModel: PhoneVerificationViewModel {
    public var action: Observable<PhoneVerificationViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<PhoneVerificationViewModelRoute> { routeSubject.asObserver() }

    public func viewDidLoad() {
    }
}
