//
//  ApplePayUseCase.swift
//  Mobile
//
//  Created by Nika Chkadua on 6/15/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation
import JavaScriptCore

protocol ApplePayUseCase {
    typealias Handler = (Result<String, Error>) -> Void
    func applePay(amount: String, handler: @escaping Handler)
}

struct DefaultApplePayUseCase: ApplePayUseCase {
    @Inject(from: .repositories) private var repo: ServiceAuthTokenRepository

    func applePay(amount: String, handler: @escaping Handler) {
        getServiceAuthToken { result in
            switch result {
            case .success(let entity): handler(.success(entity))
            case .failure(let error): handler(.failure(error))
            }
        }
    }

    func getServiceAuthToken(handler: @escaping Handler) {
        repo.token(providerId: "1db5833e-d0cf-4995-a2ad-64d6e6ffeefc") { result in
            switch result {
            case .success(let entity): handler(.success(entity))
            case .failure(let error): handler(.failure(error))
            }
        }
    }
}
