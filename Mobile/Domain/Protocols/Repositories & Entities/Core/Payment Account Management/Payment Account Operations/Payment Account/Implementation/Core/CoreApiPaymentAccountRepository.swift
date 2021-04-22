//
//  CoreApiPaymentAccountRepository.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 1/26/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

public struct CoreApiPaymentAccountRepository: CoreApiRepository { }

extension CoreApiPaymentAccountRepository: PaymentAccountPagingableRepository,
                                           PaymentAccountDeletableRepository {
    func count(params: PaymentAccountPagingableCountParams,
               handler: @escaping CountHandler) {
        performTask(expecting: CoreApiPaymentAccountCountDTO.self, completion: handler) { requestBuilder in
            return requestBuilder
                .setBody(key: .req, value: "getPaymentAccountsCount")
        }
    }

    func page(params: PaymentAccountPagingablePageParams, handler: @escaping PageHandler) {
        performTask(expecting: CoreApiPaymentAccountDTO.self, completion: handler) { requestBuilder in
            return requestBuilder
                .setBody(key: .req, value: "getPaymentAccounts")
                .setBody(key: "pageIndex", value: "\(params.index)")
                .setBody(key: "maxResult", value: "\(params.count)")
        }
    }

    func delete(params: PaymentAccountDeleteParams, completion: @escaping PaymentAccountDeleteHandler) {
        performTask(expecting: CoreApiPaymentAccountDeleteDTO.self, completion: completion) { requestBuilder -> CoreRequestBuilder in
            return requestBuilder
                .setBody(key: .req, value: "deletePaymentAccount")
                .setBody(key: "paymentAccountID", value: "\(params.id)")
        }
    }
}
