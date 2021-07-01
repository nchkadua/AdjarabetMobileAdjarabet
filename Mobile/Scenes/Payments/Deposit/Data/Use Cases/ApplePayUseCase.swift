//
//  ApplePayUseCase.swift
//  Mobile
//
//  Created by Nika Chkadua on 6/15/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation
import PassKit

protocol ApplePayUseCase {
    typealias ServiceAuthTokenHandler = (Result<String, Error>) -> Void
    typealias Handler = (Result<PKPaymentRequest, Error>) -> Void
    func applePay(amount: String, handler: @escaping Handler)
}

struct DefaultApplePayUseCase: ApplePayUseCase {
    @Inject(from: .repositories) private var repo: ServiceAuthTokenRepository
    @Inject private var userSession: UserSessionServices

    func applePay(amount: String, handler: @escaping Handler) {
        getServiceAuthToken { result in
            switch result {
            case .success(let entity):
                let paymentResult = createPaymentRequest(entity, Double(amount) ?? 0.0)
                switch paymentResult {
                case .success(let request): handler(.success(request))
                case .error(let error): handler(.failure(error))
                }
            case .failure(let error): handler(.failure(error))
            }
        }
    }

    func getServiceAuthToken(handler: @escaping ServiceAuthTokenHandler) {
        repo.token(providerId: "1db5833e-d0cf-4995-a2ad-64d6e6ffeefc") { result in
            switch result {
            case .success(let entity): handler(.success(entity))
            case .failure(let error): handler(.failure(error))
            }
        }
    }

    private func createPaymentRequest(_ token: String, _ amount: Double) -> PaymentRequestResponse {
        let request = PKPaymentRequest()
        request.merchantIdentifier = "merchant.com.adjarabet.web"
        request.supportedNetworks = [.visa, .masterCard]
        request.merchantCapabilities = .capability3DS
        request.countryCode = "GE" // Needs to be dynamic
        request.currencyCode = Currency(currencyId: userSession.currencyId ?? 2)?.description.abbreviation ?? "GEL"
        request.requiredShippingContactFields = [.name]

        request.paymentSummaryItems = [
            PKPaymentSummaryItem(label: "Merchant", amount: NSDecimalNumber(value: amount), type: .final)
        ]

        do {
            let jsonData = try JSONEncoder().encode(JSParams(token: token))
            request.applicationData = jsonData
            return .success(request)
        } catch {
            print(error)
            return .error(error)
        }
    }
}

struct JSParams: Codable {
    let token: String
    let ip = "80.241.246.253" // Static unknown ipw

    enum CodingKeys: String, CodingKey {
        case token
        case ip
    }
}

enum PaymentRequestResponse {
    case success(PKPaymentRequest)
    case error(Error)
}
