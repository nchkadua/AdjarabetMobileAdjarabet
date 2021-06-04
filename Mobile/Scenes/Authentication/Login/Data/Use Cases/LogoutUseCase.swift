//
//  LogoutUseCase.swift
//  Mobile
//
//  Created by Nika Chkadua on 2/17/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

public protocol LogoutUseCase {
    @discardableResult
    func execute(userId: Int, sessionId: String, completion: @escaping (Result<LogoutUseCaseSuccess, LogoutUseCaseError>) -> Void) -> Cancellable?
}

public enum LogoutUseCaseSuccess {
    case success
}

public enum LogoutUseCaseError: Error, LocalizedError {
    case unknown(error: Error)

    public var errorDescription: String? {
        switch self {
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}

public final class DefaultLogoutUseCase: LogoutUseCase {
    @Inject(from: .repositories) private var authenticationRepository: AuthenticationRepository

    public func execute(userId: Int, sessionId: String, completion: @escaping (Result<LogoutUseCaseSuccess, LogoutUseCaseError>) -> Void) -> Cancellable? {
        authenticationRepository.logout(userId: userId, sessionId: sessionId) {(result: Result<AdjarabetCoreResult.Logout, Error>) in
            switch result {
            case .success:
                completion(.success(.success))
            case .failure(let error):
                completion(.failure(.unknown(error: error)))
            }
        }
    }
}
