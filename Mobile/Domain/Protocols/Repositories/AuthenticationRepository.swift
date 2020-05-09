//
//  AuthenticationRepository.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 5/9/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public protocol AuthenticationRepository {
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
