//
//  PaymentAccountUseCase.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 1/26/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

public struct PaymentAccountUseCaseParams { }

public struct PaymentAccountUseCaseDeleteParams {
    let id: Int64
}

public protocol PaymentAccountUseCase {
    /**
     Returns currently available ALL payment accounts and their details
     for the currently authenticated user
     */
    typealias PaymentAccountUseCaseHandler = (Result<[PaymentAccountEntity], Error>) -> Void
    func execute(params: PaymentAccountUseCaseParams, completion: @escaping PaymentAccountUseCaseHandler)

    /**
     Deletes payment account specified by payment account ID
     for the currently authenticated user
     */
    typealias PaymentAccountUseCaseDeleteHandler = (Result<Void, Error>) -> Void
    func execute(params: PaymentAccountUseCaseDeleteParams, completion: @escaping PaymentAccountUseCaseDeleteHandler)
}

public struct DefaultPaymentAccountUseCase: PaymentAccountUseCase {
    private let coreReadableRepo: PaymentAccountPagingableRepository = CoreApiPaymentAccountRepository()
    private let coreWritableRepo: PaymentAccountDeletableRepository = CoreApiPaymentAccountRepository()

    public func execute(params: PaymentAccountUseCaseParams, completion: @escaping PaymentAccountUseCaseHandler) {
        // fetch count
        coreReadableRepo.count(params: .init()) { result in
            switch result {
            case .success(let count):
                // fetch payment accounts
                coreReadableRepo.page(params: .init(index: 0, count: count.count ?? 0), // FIXME: ?? error
                                      handler: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    public func execute(params: PaymentAccountUseCaseDeleteParams,
                        completion: @escaping PaymentAccountUseCaseDeleteHandler) {
        // delete payment account
        coreWritableRepo.delete(params: .init(id: params.id)) { result in
            switch result {
            case .success(let statusCode):
                if statusCode == 10 { // TODO: 10 is success status code, refactor with enum
                    completion(.success(()))
                } else {
                    completion(.failure(AdjarabetCoreClientError.coreError(description: "The operation did not succeed"))) // TODO: localize
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
