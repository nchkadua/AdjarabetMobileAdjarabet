//
//  BiometricLoginUseCase.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 7/19/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

protocol BiometricLoginUseCase {
    @discardableResult
    func execute(biometricSuccess: @escaping () -> Void, completion: @escaping (Result<LoginUseCaseSuccess, ABError>) -> Void) -> Cancellable?
    var isAvailable: Bool { get }
    var icon: UIImage? { get }
    var title: String? { get }
}

public final class DefaultBiometricLoginUseCase: BiometricLoginUseCase {
    @Inject private var biometricAuthentication: BiometricAuthentication
    @Inject private var userSession: UserSessionServices

    private let loginUseCase: LoginUseCase

    init(loginUseCase: LoginUseCase) {
        self.loginUseCase = loginUseCase
    }

    public var isAvailable: Bool {
        biometricAuthentication.isAvailable && userSession.hasUsernameAndPassword
    }

    public var icon: UIImage? { biometricAuthentication.icon }

    public var title: String? { biometricAuthentication.title }

    func execute(biometricSuccess: @escaping () -> Void, completion: @escaping (Result<LoginUseCaseSuccess, ABError>) -> Void) -> Cancellable? {
        guard let username = userSession.username, let password = userSession.password else {return nil}

        biometricAuthentication.authenticate { [weak self] result in
            switch result {
            case .success:
                biometricSuccess()
                self?.loginUseCase.execute(username: username, password: password, completion: completion)
            case .failure(let error):
                completion(.failure(.from(error)))
            }
        }

        return nil
    }
}
