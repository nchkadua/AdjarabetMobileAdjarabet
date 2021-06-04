//
//  OTPUseCase.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 5/17/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public protocol OTPUseCase {
    @discardableResult
    func execute(username: String, code: String, completion: @escaping (Result<Void, OTPUseCaseError>) -> Void) -> Cancellable?
}

public enum OTPUseCaseError: Error, LocalizedError {
    case invalidSMSCode
    case unknown(error: Error)

    public var errorDescription: String? {
        switch self {
        case .invalidSMSCode:
            return "Failed because invalid code was specified"
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}

public final class DefaultOTPUseCase: OTPUseCase {
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

    public func execute(username: String, code: String, completion: @escaping (Result<Void, OTPUseCaseError>) -> Void) -> Cancellable? {
        authenticationRepository.login(username: username, code: code, loginType: .sms) { [weak self] (result: Result<AdjarabetCoreResult.Login, Error>) in
            switch result {
            case .success(let params):
                guard params.codable.statusCode == .STATUS_SUCCESS else {
                    completion(.failure(.unknown(error: AdjarabetCoreClientError.invalidStatusCode(code: params.codable.statusCode))))
                    return
                }

                if params.codable.errorCode == .OTP_NOT_FOUND {
                    completion(.failure(.invalidSMSCode))
                    return
                }

                if params.codable.isLoggedOn && params.codable.userID != nil {
                    self?.save(params: params)
                    completion(.success(()))
                } else {
                    completion(.failure(.unknown(error: AdjarabetCoreClientError.invalidStatusCode(code: params.codable.errorCode ?? .UNKNOWN))))
                }
            case .failure(let error):
                completion(.failure(.unknown(error: error)))
            }
        }
    }
}
