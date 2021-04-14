//
//  WithdrawPaymentListUseCase.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 4/8/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

protocol WithdrawPaymentListUseCase {
    /**
     Returns list of available withdraw payment methods
     */
    typealias ListHandler = (Result<[PaymentMethodEntity], Error>) -> Void
    func list(handler: @escaping ListHandler)
}

// MARK: - Default Implementation
struct DefaultWithdrawPaymentListUseCase: WithdrawPaymentListUseCase {
    @Inject(from: .useCases) private var paymentListUseCase: PaymentListUseCase

    func list(handler: @escaping ListHandler) {
        paymentListUseCase.list { result in
            switch result {
            case .success(let entity):
                let filtered = entity.filter {
                    // TEMP: fix with correct logic
                    let flowId = $0.flowId.lowercased()
                    return flowId.contains("withdraw_tbc_ufc_vip") || flowId.contains("withdraw_tbc_ufc_regular")
                }
                handler(.success(filtered))
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}
