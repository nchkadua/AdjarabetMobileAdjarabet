//
//  PhoneNumberChangeViewModel.swift
//  Mobile
//
//  Created by Nika Chkadua on 11/30/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift
import  CoreLocation

public protocol PhoneNumberChangeViewModel: PhoneNumberChangeViewModelInput, PhoneNumberChangeViewModelOutput {
}

public struct PhoneNumberChangeViewModelParams {
    public init () {
    }
}

public protocol PhoneNumberChangeViewModelInput: AnyObject {
    var params: PhoneNumberChangeViewModelParams { get set }
    func viewDidLoad()
}

public protocol PhoneNumberChangeViewModelOutput {
    var action: Observable<PhoneNumberChangeViewModelOutputAction> { get }
    var route: Observable<PhoneNumberChangeViewModelRoute> { get }
}

public enum PhoneNumberChangeViewModelOutputAction {
    case selectLocalePhonePrefix(localePrefix: String)
}

public enum PhoneNumberChangeViewModelRoute {
}

public class DefaultPhoneNumberChangeViewModel {
    public var params: PhoneNumberChangeViewModelParams
    private let actionSubject = PublishSubject<PhoneNumberChangeViewModelOutputAction>()
    private let routeSubject = PublishSubject<PhoneNumberChangeViewModelRoute>()

    public init(params: PhoneNumberChangeViewModelParams) {
        self.params = params
    }
}

extension DefaultPhoneNumberChangeViewModel: PhoneNumberChangeViewModel {
    public var action: Observable<PhoneNumberChangeViewModelOutputAction> { actionSubject.asObserver() }
    public var route: Observable<PhoneNumberChangeViewModelRoute> { routeSubject.asObserver() }

    public func viewDidLoad() {
        actionSubject.onNext(.selectLocalePhonePrefix(localePrefix: Locale.current.languageCode ?? ""))
    }
}
