//
//  AuthenticationRepository.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 5/9/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

protocol AuthenticationRepository {
    @discardableResult
    func login<T: HeaderProvidingCodableType>(username: String, password: String, channel: OTPDeliveryChannel, completion: @escaping (Result<T, ABError>) -> Void) -> Cancellable
    @discardableResult
    func login<T: HeaderProvidingCodableType>(username: String, code: String, loginType: LoginType, completion: @escaping (Result<T, ABError>) -> Void) -> Cancellable
    @discardableResult
    func smsCode<T: HeaderProvidingCodableType>(username: String, channel: OTPDeliveryChannel, completion: @escaping (Result<T, ABError>) -> Void) -> Cancellable
    @discardableResult
    func logout<T: HeaderProvidingCodableType>(userId: Int, sessionId: String, completion: @escaping (Result<T, ABError>) -> Void) -> Cancellable
}
