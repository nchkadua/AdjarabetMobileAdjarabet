//
//  UserSessionServices.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/12/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public protocol UserSessionServices: UserSessionReadableServices, UserSessionWritableServices {
}

extension UserSessionServices {
    func logout() {
        clear()
    }
}

public protocol UserSessionReadableServices {
    var isLogedIn: Bool { get }
    var userId: Int? { get }
    var username: String? { get }
    var sessionId: String? { get }
    var currencyId: Int? { get }
}

public protocol UserSessionWritableServices {
    func logout()
    func set(isLoggedIn: Bool)
    func set(userId: Int, username: String, sessionId: String, currencyId: Int?)
    func clear()
}
