//
//  OTPUseCase.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 5/17/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

protocol OTPUseCase {
    @discardableResult
    func execute(username: String, code: String, loginType: LoginType, completion: @escaping (Result<Void, OTPUseCaseError>) -> Void) -> Cancellable?
}

enum OTPUseCaseError: Error, LocalizedError {
    case invalidSMSCode
    case unknown(error: ABError)

    var errorDescription: String? {
        switch self {
        case .invalidSMSCode:
            return "Failed because invalid code was specified"
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}

final class DefaultOTPUseCase: OTPUseCase {
    @Inject(from: .repositories) private var authenticationRepository: AuthenticationRepository
    @Inject private var userSession: UserSessionServices

    private func save(params: AdjarabetCoreResult.Login) {
        userSession.set(userId: params.codable.userID ?? -1,
                        username: params.codable.username ?? "",
                        sessionId: params.header?.sessionId ?? "",
                        currencyId: params.codable.preferredCurrency,
                        password: nil)

        userSession.login()
    }

    func execute(username: String, code: String, loginType: LoginType, completion: @escaping (Result<Void, OTPUseCaseError>) -> Void) -> Cancellable? {
        authenticationRepository.login(username: username, code: code, loginType: loginType) { [weak self] (result: Result<AdjarabetCoreResult.Login, ABError>) in
            switch result {
            case .success(let params):
                guard params.codable.statusCode == .STATUS_SUCCESS else {
                    let error = ABError(coreStatusCode: params.codable.statusCode) ?? ABError(type: .default)
                    completion(.failure(.unknown(error: error)))
                    return
                }

                if let error = ABError(coreStatusCode: params.codable.errorCode ?? .STATUS_SUCCESS) {
                    completion(.failure(.unknown(error: error)))
                    return
                }

                if params.codable.isLoggedOn && params.codable.userID != nil {
                    self?.save(params: params)
                    completion(.success(()))
                } else {
                    let error = ABError(coreStatusCode: params.codable.statusCode) ?? ABError(type: .default)
                    completion(.failure(.unknown(error: error)))
                }
            case .failure(let error):
                completion(.failure(.unknown(error: error)))
            }
        }
    }
}
