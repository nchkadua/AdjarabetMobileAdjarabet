//
//  UFCWithdrawUseCase.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 3/16/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

struct UFCWithdrawUseCase {
    @Inject(from: .repositories) private var withdrawRepo: UFCWithdrawRepository
    @Inject(from: .factories) private var paramsFactory: UFCTransactionParamsFactory
    private var httpRequestBuilder: HttpRequestBuilder { HttpRequestBuilderImpl.createInstance() }

    typealias InitWithdrawHandler = (Result<UFCInitWithdrawEntity, ABError>) -> Void
    func execute(serviceType: UFCServiceType,
                 amount: Double,
                 accountId: Int64? = nil,
                 handler: @escaping InitWithdrawHandler) {
        let parameters = paramsFactory.make(serviceType: serviceType,
                                            amount: amount,
                                            accountId: accountId)

        withdrawRepo.initWithdraw(with: parameters, handler)
    }

    typealias WithdrawHandler = (Result<Void, ABError>) -> Void
    func execute(serviceType: UFCServiceType,
                 amount: Double,
                 accountId: Int64? = nil,
                 session: String,
                 handler: @escaping WithdrawHandler) {
        let parameters = paramsFactory.make(serviceType: serviceType,
                                            amount: amount,
                                            accountId: accountId,
                                            session: session)

        withdrawRepo.withdraw(with: parameters, handler)
    }
}
