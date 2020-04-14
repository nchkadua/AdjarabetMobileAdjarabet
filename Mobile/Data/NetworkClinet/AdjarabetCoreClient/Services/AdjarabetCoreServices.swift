//
//  AdjarabetCoreServices.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/12/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public protocol AdjarabetCoreServices: AuthenticationService, SessionManagementServices, BalanceManagementServices { }

public protocol AuthenticationService {
    func login<T: AdjarabetCoreCodableType>(username: String, password: String, channel: Int, completion: @escaping (Result<T, Error>) -> Void)
    func smsCode<T: AdjarabetCoreCodableType>(username: String, channel: Int, completion: @escaping (Result<T, Error>) -> Void)
    func logout<T: AdjarabetCoreCodableType>(userId: Int, sessionId: String, completion: @escaping (Result<T, Error>) -> Void)
    func login<T: AdjarabetCoreCodableType>(username: String, code: String, loginType: LoginType, completion: @escaping (Result<T, Error>) -> Void)
}

public enum LoginType: String {
    case otp, sms
}

public protocol SessionManagementServices {
    func aliveSession<T: AdjarabetCoreCodableType>(userId: Int, sessionId: String, completion: @escaping (Result<T, Error>) -> Void)
}

public protocol BalanceManagementServices {
    func balance<T: AdjarabetCoreCodableType>(userId: Int, currencyId: Int, isSingle: Int, sessionId: String, completion: @escaping (Result<T, Error>) -> Void)
}
