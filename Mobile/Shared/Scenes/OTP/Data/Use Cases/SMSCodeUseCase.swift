//
//  SendSMSCodeUseCase.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 5/17/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

protocol SMSCodeUseCase {
    @discardableResult
    func execute(username: String, completion: @escaping (Result<Void, ABError>) -> Void) -> Cancellable?
}

final class DefaultSMSCodeUseCase: SMSCodeUseCase {
    @Inject(from: .repositories) private var authenticationRepository: AuthenticationRepository

    func execute(username: String, completion: @escaping (Result<Void, ABError>) -> Void) -> Cancellable? {
        authenticationRepository.smsCode(username: username, channel: .sms) { (result: Result<AdjarabetCoreResult.SmsCode, ABError>) in
            switch result {
            case .success(let params):
                if params.codable.statusCode == .OTP_IS_SENT { // TODO: apply correct success condition
                    completion(.success(()))
                } else {
                    let error = ABError(coreStatusCode: params.codable.statusCode) ?? ABError(type: .default)
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
