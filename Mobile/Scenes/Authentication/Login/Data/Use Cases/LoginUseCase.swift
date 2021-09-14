//
//  LoginUseCase.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 5/17/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

protocol LoginUseCase {
    @discardableResult
    func execute(username: String, password: String, completion: @escaping (Result<LoginUseCaseSuccess, ABError>) -> Void) -> Cancellable?
}

enum LoginUseCaseSuccess {
    case success(params: MainContainerViewModelParams)
    case otpRequried(username: String)
    case openNotVerifiedUserPage
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
    @Inject(from: .repositories) private var cookieStorageRepository: CookieStorageRepository
    @Inject(from: .repositories) private var userInfoRepo: UserInfoReadableRepository
    @Inject private var userSession: UserSessionServices

    private func save(params: AdjarabetCoreResult.Login, password: String) {
        cookieStorageRepository.update(headerFields: params.header?.fields.toStringValues() ?? [:])

        userSession.set(userId: params.codable.userID ?? -1,
                        username: params.codable.username ?? "",
                        sessionId: params.header?.sessionId ?? "",
                        currencyId: params.codable.preferredCurrency,
                        password: password)

        userSession.login()
    }

    func execute(username: String, password: String, completion: @escaping (Result<LoginUseCaseSuccess, ABError>) -> Void) -> Cancellable? {
        authenticationRepository.login(username: username, password: password, channel: .sms) { [weak self] (result: Result<AdjarabetCoreResult.Login, ABError>) in
            switch result {
            case .success(let params):
                guard params.codable.statusCode == .STATUS_SUCCESS else {
                    completion(.failure(.init()))
                    return
                }

                if params.codable.errorCode == .USER_WITH_GIVEN_AUTH_CREDENTIALS_NOT_FOUND {
                    completion(.failure(.init(type: .wrongAuthCredentials)))
                    return
                }

                if params.codable.errorCode == .IP_IS_BLOCKED {
                    completion(.failure(.init(type: .ipIsBlocked)))
                    return
                }

                if params.codable.isOTPRequired && params.codable.errorCode == .OTP_IS_REQUIRED {
                    completion(.success(.otpRequried(username: username)))
                } else if params.codable.isLoggedOn && params.codable.userID != nil {
                    self?.userInfoRepo.getIDDocuments(params: .init(userId: String(params.codable.userID ?? -1), header: params.header?.sessionId)) { [weak self] result in
                        switch result {
                        case .success(let entity):
                            if entity.idDocuments.first?.documentStatus == 1 {
                                self?.save(params: params, password: password)
                                let pageParams = { () -> MainContainerViewModelParams in
                                    if params.codable.errorCode == .LAST_ACCESS_FROM_DIFFERENT_IP {
                                        return .init(homeParams: .init(error: .init(type: .lastAccessFromDifferentIP)))
                                    }
                                    return .init()
                                }()
                                completion(.success(.success(params: pageParams)))
                            } else {
                                completion(.success(.openNotVerifiedUserPage))
                            }
                        case .failure(_): completion(.failure(.init()))
                        }
                    }
                } else {
                    completion(.failure(.init()))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
