//
//  LoginUseCase.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 5/17/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

public protocol LoginUseCase {
    @discardableResult
    func execute(username: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) -> Cancellable?
}

public final class DefaultLoginUseCase: LoginUseCase {
    @Inject(from: .repositories) private var authenticationRepository: AuthenticationRepository
    @Inject private var userSession: UserSessionServices

    private func save(params: AdjarabetCoreResult.Login) {
        userSession.set(userId: params.codable.userID,
                        username: params.codable.username,
                        sessionId: params.header!.sessionId,
                        currencyId: params.codable.preferredCurrency)

        userSession.login()
    }

    public func execute(username: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) -> Cancellable? {
        authenticationRepository.login(username: username, password: password, channel: 0) { [weak self] (result: Result<AdjarabetCoreResult.Login, Error>) in
            switch result {
            case .success(let params):
                self?.save(params: params)
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
