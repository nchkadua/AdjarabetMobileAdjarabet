//
//  AuthenticationRepository.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 5/9/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

public class DefaultAuthenticationRepository {
    @Inject private var dataTransferService: DataTransfer
    @Inject private var requestBuilder: AdjarabetCoreClientRequestBuilder
}

extension DefaultAuthenticationRepository: AuthenticationRepository {
    public func login<T>(username: String, password: String, channel: Int, completion: @escaping (Result<T, Error>) -> Void) -> Cancellable where T: AdjarabetCoreCodableType {
        let request = requestBuilder
            .set(method: .login)
            .set(username: username, password: password, channel: channel)
            .build()

        return dataTransferService.performTask(request: request, respondOnQueue: .main, completion: completion)
    }

    public func smsCode<T>(username: String, channel: Int, completion: @escaping (Result<T, Error>) -> Void) -> Cancellable where T: AdjarabetCoreCodableType {
        let request = requestBuilder
            .set(method: .smsCode)
            .set(username: username, channel: channel)
            .build()

        return dataTransferService.performTask(request: request, respondOnQueue: .main, completion: completion)
    }

    public func logout<T>(userId: Int, sessionId: String, completion: @escaping (Result<T, Error>) -> Void) -> Cancellable where T: AdjarabetCoreCodableType {
        let request = requestBuilder
            .set(method: .logout)
            .set(userId: userId)
            .setHeader(key: .cookie, value: sessionId)
            .build()

        return dataTransferService.performTask(request: request, respondOnQueue: .main, completion: completion)
    }

    public func login<T>(username: String, code: String, loginType: LoginType, completion: @escaping (Result<T, Error>) -> Void) -> Cancellable where T: AdjarabetCoreCodableType {
        let request = requestBuilder
            .set(method: .loginOtp)
            .set(username: username, code: code, loginType: loginType)
            .build()

        return dataTransferService.performTask(request: request, respondOnQueue: .main, completion: completion)
    }
}
