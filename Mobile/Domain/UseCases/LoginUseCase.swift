//
//  LoginUseCase.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 5/17/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public protocol LoginUseCase {
    @discardableResult
    func execute(username: String, password: String, completion: @escaping (Result<LoginUseCaseSuccess, LoginUseCaseError>) -> Void) -> Cancellable?
}

public enum LoginUseCaseSuccess {
    case success
    case otpRequried
}

public enum LoginUseCaseError: Error, LocalizedError {
    case invalidUsernameOrPassword
    case unknown(error: Error)

    public var errorDescription: String? {
        switch self {
        case .invalidUsernameOrPassword:
            return "Failed because invalid password was specified"
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}

public final class DefaultLoginUseCase: LoginUseCase {
    @Inject(from: .repositories) private var authenticationRepository: AuthenticationRepository
    @Inject private var userSession: UserSessionServices

    private func save(params: AdjarabetCoreResult.Login) {
        userSession.set(userId: params.codable.userID ?? -1,
                        username: params.codable.username ?? "",
                        sessionId: params.header?.sessionId ?? "",
                        currencyId: params.codable.preferredCurrency)

        userSession.login()
    }

    public func execute(username: String, password: String, completion: @escaping (Result<LoginUseCaseSuccess, LoginUseCaseError>) -> Void) -> Cancellable? {
        authenticationRepository.login(username: username, password: password, channel: 0) { [weak self] (result: Result<AdjarabetCoreResult.Login, Error>) in
            switch result {
            case .success(let params):
                guard params.codable.statusCode == .STATUS_SUCCESS else {
                    completion(.failure(.unknown(error: AdjarabetCoreClientError.invalidStatusCode(code: params.codable.statusCode))))
                    return
                }

                guard params.codable.isLoggedOn else {
                    completion(.failure(.invalidUsernameOrPassword))
                    return
                }

                if params.codable.isOTPRequired {
                    completion(.success(.otpRequried))
                } else if params.codable.userID != nil {
                    self?.save(params: params)
                    completion(.success(.success))
                } else {
                    completion(.failure(.unknown(error: AdjarabetCoreClientError.invalidStatusCode(code: params.codable.statusCode))))
                }
            case .failure(let error):
                completion(.failure(.unknown(error: error)))
            }
        }
    }
}
