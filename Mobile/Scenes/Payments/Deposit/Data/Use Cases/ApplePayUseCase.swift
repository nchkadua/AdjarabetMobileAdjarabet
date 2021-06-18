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
            case .success(let entity): loadJS(token: entity)
            case .failure(let error): handler(.failure(error))
            }
        }
    }

    private func loadJS(token: String) {
        let jsContext = JSContext()

        if let jsSourcePath = Bundle.main.path(forResource: "ApplePayScript", ofType: "js") {
            do {
                let jsSourceContents = try String(contentsOfFile: jsSourcePath)

                jsContext?.evaluateScript(jsSourceContents)
                jsContext?.evaluateScript("makePaymentSwift(\("1.00"),\("GEL"),\("GE"),\(token));")
            } catch {
                print(error.localizedDescription)
            }
        } else {
            print("js not found")
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
