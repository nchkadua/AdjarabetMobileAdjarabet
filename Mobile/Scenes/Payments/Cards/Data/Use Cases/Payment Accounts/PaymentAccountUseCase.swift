//
//  PaymentAccountUseCase.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 1/26/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

struct PaymentAccountUseCaseParams { }

struct PaymentAccountUseCaseDeleteParams {
    let id: Int64
}

protocol PaymentAccountUseCase {
    /**
     Returns currently available ALL payment accounts and their details
     for the currently authenticated user
     */
    typealias PaymentAccountUseCaseHandler = (Result<[PaymentAccountEntity], ABError>) -> Void
    func execute(params: PaymentAccountUseCaseParams,
                 completion: @escaping PaymentAccountUseCaseHandler)

    /**
     Deletes payment account specified by payment account ID
     for the currently authenticated user
     */
    typealias PaymentAccountUseCaseDeleteHandler = (Result<Void, ABError>) -> Void
    func execute(params: PaymentAccountUseCaseDeleteParams,
                 completion: @escaping PaymentAccountUseCaseDeleteHandler)
}

struct DefaultPaymentAccountUseCase: PaymentAccountUseCase {
    private let coreReadableRepo: PaymentAccountPagingableRepository = CoreApiPaymentAccountRepository()
    private let coreWritableRepo: PaymentAccountDeletableRepository = CoreApiPaymentAccountRepository()
    private let webWritableRepo: PaymentAccountDeletableRepository = WebApiPaymentAccountRepository()

    func execute(params: PaymentAccountUseCaseParams,
                 completion: @escaping PaymentAccountUseCaseHandler) {
        // fetch count
        coreReadableRepo.count(params: .init()) { result in
            switch result {
            case .success(let count):
                // fetch payment accounts
                coreReadableRepo.page(params: .init(index: 0, count: count.count),
                                      handler: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func execute(params: PaymentAccountUseCaseDeleteParams,
                 completion: @escaping PaymentAccountUseCaseDeleteHandler) {
        // delete payment account
        coreWritableRepo.delete(params: .init(id: params.id)) { result in
            switch result {
            case .success:
                webWritableRepo.delete(params: .init(id: params.id), handler: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
