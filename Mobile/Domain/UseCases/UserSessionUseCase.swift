//
//  UserSessionUseCase.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 5/24/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public protocol UserSessionUseCase {
    @discardableResult
    func execute(userId: Int, sessionId: String, completion: @escaping (Result<Void, Error>) -> Void) -> Cancellable?
}

public final class DefaultUserSessionUseCase: UserSessionUseCase {
    @Inject(from: .repositories) private var sessionManagementRepository: SessionManagementRepository

    public func execute(userId: Int, sessionId: String, completion: @escaping (Result<Void, Error>) -> Void) -> Cancellable? {
        sessionManagementRepository.aliveSession(userId: userId, sessionId: sessionId) { (result: Result<AdjarabetCoreResult.AliveSession, Error>) in
            switch result {
            case .success(let params):
                if params.codable.statusCode == .STATUS_SUCCESS {
                    completion(.success(()))
                } else {
                    completion(.failure(AdjarabetCoreClientError.invalidStatusCode(code: params.codable.statusCode)))
                }
            case .failure(let error): completion(.failure(error))
            }
        }
    }
}
