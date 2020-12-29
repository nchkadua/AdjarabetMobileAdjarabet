//
//  DefaultAuthenticationRepository.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 5/9/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

public class DefaultAuthenticationRepository {
    @Inject private var dataTransferService: DataTransferService
    private var requestBuilder: CoreRequestBuilder { CoreRequestBuilder() }
}

extension DefaultAuthenticationRepository: AuthenticationRepository {
    public func login<T>(username: String, password: String, channel: OTPDeliveryChannel, completion: @escaping (Result<T, Error>) -> Void) -> Cancellable where T: HeaderProvidingCodableType {
        let request = requestBuilder
            .setBody(key: .req, value: "login")
            .set(username: username, password: password, channel: channel.rawValue)
            .build()

        return dataTransferService.performTask(request: request, respondOnQueue: .main, completion: completion)
    }

    public func smsCode<T>(username: String, channel: OTPDeliveryChannel, completion: @escaping (Result<T, Error>) -> Void) -> Cancellable where T: HeaderProvidingCodableType {
        let request = requestBuilder
            .setBody(key: .req, value: "getSmsCode")
            .set(username: username, channel: channel.rawValue)
            .build()

        return dataTransferService.performTask(request: request, respondOnQueue: .main, completion: completion)
    }

    public func logout<T>(userId: Int, sessionId: String, completion: @escaping (Result<T, Error>) -> Void) -> Cancellable where T: HeaderProvidingCodableType {
        let request = requestBuilder
            .setBody(key: .req, value: "logout")
            .set(userId: userId)
            .setHeader(key: .cookie, value: sessionId)
            .build()

        return dataTransferService.performTask(request: request, respondOnQueue: .main, completion: completion)
    }

    public func login<T>(username: String, code: String, loginType: LoginType, completion: @escaping (Result<T, Error>) -> Void) -> Cancellable where T: HeaderProvidingCodableType {
        let request = requestBuilder
            .setBody(key: .req, value: "loginOtp")
            .set(username: username, code: code, loginType: loginType)
            .build()

        return dataTransferService.performTask(request: request, respondOnQueue: .main, completion: completion)
    }
}
