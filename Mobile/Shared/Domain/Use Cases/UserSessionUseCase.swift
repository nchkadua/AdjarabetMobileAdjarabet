//
//  UserSessionUseCase.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 5/24/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

protocol UserSessionUseCase {
    @discardableResult
    func execute(userId: Int, sessionId: String, completion: @escaping (Result<Void, ABError>) -> Void) -> Cancellable?
}

final class DefaultUserSessionUseCase: UserSessionUseCase {
    @Inject(from: .repositories) private var sessionManagementRepository: SessionManagementRepository

    func execute(userId: Int, sessionId: String, completion: @escaping (Result<Void, ABError>) -> Void) -> Cancellable? {
        sessionManagementRepository.aliveSession(userId: userId, sessionId: sessionId) { (result: Result<AdjarabetCoreResult.AliveSession, ABError>) in
            switch result {
            case .success(let params):
                if params.codable.statusCode == .STATUS_SUCCESS { // TODO: apply correct success condition
                    completion(.success(()))
                } else {
                    let error = ABError(coreStatusCode: params.codable.statusCode) ?? ABError(type: .default)
                    completion(.failure(error))
                }
            case .failure(let error): completion(.failure(error))
            }
        }
    }
}
