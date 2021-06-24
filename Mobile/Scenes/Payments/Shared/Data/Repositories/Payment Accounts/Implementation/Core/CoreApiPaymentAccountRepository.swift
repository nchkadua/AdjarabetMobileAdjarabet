//
//  CoreApiPaymentAccountRepository.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 1/26/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

struct CoreApiPaymentAccountRepository: CoreApiRepository { }

extension CoreApiPaymentAccountRepository: PaymentAccountPagingableRepository,
                                           PaymentAccountDeletableRepository,
                                           PaymentAccountFilterableRepository {
    func count(params: PaymentAccountPagingableCountParams,
               handler: @escaping CountHandler) {
        performTask(expecting: CoreApiPaymentAccountCountDTO.self, completion: handler) { requestBuilder in
            return requestBuilder
                .setBody(key: .req, value: "getPaymentAccountsCount")
        }
    }

    func page(params: PaymentAccountPagingablePageParams,
              handler: @escaping PageHandler) {
        performTask(expecting: CoreApiPaymentAccountDTO.self, completion: handler) { requestBuilder in
            return requestBuilder
                .setBody(key: .req, value: "getPaymentAccounts")
                .setBody(key: "pageIndex", value: "\(params.index)")
                .setBody(key: "maxResult", value: "\(params.count)")
        }
    }

    func delete(params: PaymentAccountDeleteParams,
                handler: @escaping PaymentAccountDeleteHandler) {
        performTask(expecting: CoreApiStatusCodeDTO.self, completion: handler) { requestBuilder -> CoreRequestBuilder in
            return requestBuilder
                .setBody(key: .req, value: "deletePaymentAccount")
                .setBody(key: "paymentAccountID", value: "\(params.id)")
        }
    }

    func list(params: PaymentAccountFilterableListParams,
              handler: @escaping ListHandler) {
        performTask(expecting: CoreApiPaymentAccountDTO.self, completion: handler) { requestBuilder in
            return requestBuilder
                .setBody(key: .req, value: "getPaymentAccounts")
                .setBody(key: "pageIndex", value: "0")   // first page
                .setBody(key: "maxResult", value: "100") // first 100 cards
                .setBody(key: "providerID", value: params.providerType.providerId)
                .setBody(key: "pay_type", value: params.paymentType.stringValue)
        }
    }
}
