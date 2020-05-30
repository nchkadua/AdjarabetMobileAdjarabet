//
//  SendSMSCodeUseCase.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 5/17/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public protocol SMSCodeUseCase {
    @discardableResult
    func execute(username: String, completion: @escaping (Result<Void, Error>) -> Void) -> Cancellable?
}

public final class DefaultSMSCodeUseCase: SMSCodeUseCase {
    @Inject(from: .repositories) private var authenticationRepository: AuthenticationRepository

    public func execute(username: String, completion: @escaping (Result<Void, Error>) -> Void) -> Cancellable? {
        authenticationRepository.smsCode(username: username, channel: 2) { (result: Result<AdjarabetCoreResult.SmsCode, Error>) in
            switch result {
            case .success: completion(.success(()))
            case .failure(let error): completion(.failure(error))
            }
        }
    }
}
