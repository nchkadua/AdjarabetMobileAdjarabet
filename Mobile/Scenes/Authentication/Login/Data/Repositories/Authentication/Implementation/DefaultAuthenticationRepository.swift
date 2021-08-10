//
//  DefaultAuthenticationRepository.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 5/9/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

class DefaultAuthenticationRepository {
    @Inject private var dataTransferService: DataTransferService
    private var requestBuilder: CoreRequestBuilder { CoreRequestBuilder() }
}

extension DefaultAuthenticationRepository: AuthenticationRepository {
    func login<T>(username: String, password: String, channel: OTPDeliveryChannel, completion: @escaping (Result<T, ABError>) -> Void) -> Cancellable where T: HeaderProvidingCodableType {
        let request = requestBuilder
            .setBody(key: .req, value: "login")
            .setBody(key: .userIdentifier, value: username)
            .setBody(key: .password, value: password)
            .setBody(key: .otpDeliveryChannel, value: "\(channel.rawValue)")
            .build()

        return dataTransferService.performTask(request: request, respondOnQueue: .main, completion: completion)
    }

    func smsCode<T>(username: String, channel: OTPDeliveryChannel, completion: @escaping (Result<T, ABError>) -> Void) -> Cancellable where T: HeaderProvidingCodableType {
        let request = requestBuilder
            .setBody(key: .req, value: "getSmsCode")
            .setBody(key: .userIdentifier, value: username)
            .setBody(key: .channelType, value: "\(channel.rawValue)")
            .build()

        return dataTransferService.performTask(request: request, respondOnQueue: .main, completion: completion)
    }

    func logout<T>(userId: Int, sessionId: String, completion: @escaping (Result<T, ABError>) -> Void) -> Cancellable where T: HeaderProvidingCodableType {
        let request = requestBuilder
            .setHeader(key: .cookie, value: sessionId)
            .setBody(key: .req, value: "logout")
            .setBody(key: .userId, value: "\(userId)")
            .build()

        return dataTransferService.performTask(request: request, respondOnQueue: .main, completion: completion)
    }

    func login<T>(username: String, code: String, loginType: LoginType, completion: @escaping (Result<T, ABError>) -> Void) -> Cancellable where T: HeaderProvidingCodableType {
        let request = requestBuilder
            .setBody(key: .req, value: "loginOtp")
            .setBody(key: .userIdentifier, value: username)
            .setBody(key: .otp, value: code)
            .setBody(key: .loginType, value: loginType.rawValue)
            .build()

        return dataTransferService.performTask(request: request, respondOnQueue: .main, completion: completion)
    }
}
