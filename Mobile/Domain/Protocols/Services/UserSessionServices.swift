//
//  UserSessionServices.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 5/4/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import RxSwift

public protocol UserSessionServices: UserSessionReadableServices, UserSessionWritableServices {
}

public protocol UserSessionReadableServices {
    var isLoggedIn: Bool { get }
    var sessionId: String? { get }
    var userId: Int? { get }
    var username: String? { get }
    var currencyId: Int? { get }
    var action: Observable<UserSessionAction> { get }
}

public protocol UserSessionWritableServices {
    func login()
    func logout()
    func set(userId: Int, username: String, sessionId: String, currencyId: Int?)
    func remove()
}

public enum UserSessionAction {
    case authentication(isLoggedIn: Bool)
    case fields
    case removed
}
