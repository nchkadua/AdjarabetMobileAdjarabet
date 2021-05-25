//
//  UFCDepositUseCase.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 3/16/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

struct UFCDepositUseCase {
    @Inject(from: .repositories) private var depositRepo: UFCDepositRepository
    @Inject(from: .factories) private var paramsFactory: UFCTransactionParamsFactory
    private var httpRequestBuilder: HttpRequestBuilder { HttpRequestBuilderImpl.createInstance() }

    typealias Handler = (Result<URLRequest, Error>) -> Void
    func execute(serviceType: UFCServiceType,
                 amount: Double,
                 accountId: Int64? = nil,   // card ID
                 saveAccount: Bool = false, // add to cards or not
                 _ handler: @escaping Handler) {
        // create parameters for Repository call
        var parameters = paramsFactory.make(serviceType: serviceType,
                                            amount: amount,
                                            accountId: accountId,
                                            saveAccount: saveAccount)
        // call init service
        depositRepo.initDeposit(with: parameters) { result in
            switch result {
            case .success(let entity):
                parameters.session = entity.session
                // call deposit service
                depositRepo.deposit(with: parameters) { result in
                    switch result {
                    case .success(let entity):

                        let headers = [
                            "Cache-control": "no-store",
                            "Connection": "Keep-Alive",
                            "Keep-Alive": "timeout=5, max=100",
                            "Pragma": "no-cache",
                            "X-Content-Type-Options": "nosniff",
                            "X-XSS-Protection": "1; mode=block"
                        ]

                        let request = httpRequestBuilder
                            .set(host: "\(entity.url)?trans_id=\(entity.transactionId)")
                            .set(headers: headers)
                            .set(method: HttpMethodGet())
                            .build()

                        handler(.success(request))

                    case .failure(let error):
                        handler(.failure(error))
                    }
                }
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}
