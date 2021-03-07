//
//  PaymentListUseCase.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 3/6/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

protocol PaymentListUseCase {
    /**
     Retusn list of available payment methods
     */
    typealias ListHandler = (Result<PaymentMethodEntity, Error>) -> Void
    func list(handler: ListHandler)
}

// MARK: - Default Implementation
struct DefaultPaymentListUseCase: PaymentListUseCase {
    @Inject(from: .repositories) private var postLoginRepo: PostLoginRepository
    @Inject(from: .repositories) private var paymentListRepo: PaymentListRepository

    func list(handler: ListHandler) {
        
    }
}
