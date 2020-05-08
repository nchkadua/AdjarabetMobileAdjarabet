//
//  AdjarabetCoreServices.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/12/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public protocol AdjarabetCoreServices: AuthenticationService, SessionManagementServices, BalanceManagementServices { }

public protocol AuthenticationService {
    @discardableResult
    func login<T: AdjarabetCoreCodableType>(username: String, password: String, channel: Int, completion: @escaping (Result<T, Error>) -> Void) -> Cancellable
    @discardableResult
    func smsCode<T: AdjarabetCoreCodableType>(username: String, channel: Int, completion: @escaping (Result<T, Error>) -> Void) -> Cancellable
    @discardableResult
    func logout<T: AdjarabetCoreCodableType>(userId: Int, sessionId: String, completion: @escaping (Result<T, Error>) -> Void) -> Cancellable
    @discardableResult
    func login<T: AdjarabetCoreCodableType>(username: String, code: String, loginType: LoginType, completion: @escaping (Result<T, Error>) -> Void) -> Cancellable
}

public enum LoginType: String {
    case otp, sms
}

public protocol SessionManagementServices {
    @discardableResult
    func aliveSession<T: AdjarabetCoreCodableType>(userId: Int, sessionId: String, completion: @escaping (Result<T, Error>) -> Void) -> Cancellable
}

public protocol BalanceManagementServices {
    @discardableResult
    func balance<T: AdjarabetCoreCodableType>(userId: Int, currencyId: Int, isSingle: Int, sessionId: String, completion: @escaping (Result<T, Error>) -> Void) -> Cancellable
}
