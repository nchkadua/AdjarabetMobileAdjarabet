//
//  LogoutUseCase.swift
//  Mobile
//
//  Created by Nika Chkadua on 2/17/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

protocol LogoutUseCase {
    @discardableResult
    func execute(userId: Int, sessionId: String, completion: @escaping (Result<LogoutUseCaseSuccess, LogoutUseCaseError>) -> Void) -> Cancellable?
}

enum LogoutUseCaseSuccess {
    case success
}

enum LogoutUseCaseError: Error, LocalizedError {
    case unknown(error: ABError)

    var errorDescription: String? {
        switch self {
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}

final class DefaultLogoutUseCase: LogoutUseCase {
    @Inject(from: .repositories) private var authenticationRepository: AuthenticationRepository

    func execute(userId: Int, sessionId: String, completion: @escaping (Result<LogoutUseCaseSuccess, LogoutUseCaseError>) -> Void) -> Cancellable? {
        authenticationRepository.logout(userId: userId, sessionId: sessionId) {(result: Result<AdjarabetCoreResult.Logout, ABError>) in
            switch result {
            case .success:
                completion(.success(.success))
            case .failure(let error):
                completion(.failure(.unknown(error: error)))
            }
        }
    }
}
