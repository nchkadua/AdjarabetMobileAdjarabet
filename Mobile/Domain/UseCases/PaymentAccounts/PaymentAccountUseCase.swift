//
//  PaymentAccountUseCase.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 1/26/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

public struct PaymentAccountUseCaseParams { }

public protocol PaymentAccountUseCase {
    /**
     Returns currently available ALL payment accounts and their details
     for the currently authenticated user
     */
    typealias PaymentAccountUseCaseHandler = (Result<[PaymentAccountEntity], Error>) -> Void
    func execute(params: PaymentAccountUseCaseParams, completion: @escaping PaymentAccountUseCaseHandler)
}

public struct DefaultPaymentAccountUseCase: PaymentAccountUseCase {
    @Inject(from: .repositories) private var paymentAccountRepository: PaymentAccountRepository

    public func execute(params: PaymentAccountUseCaseParams, completion: @escaping PaymentAccountUseCaseHandler) {
        paymentAccountRepository.currentUserPaymentAccountsCount(params: .init()) { (result) in
            switch result {
            case .success(let count):
                print(count)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
