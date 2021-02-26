//
//  CoreApiPaymentAccountRepository.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 1/26/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

public struct CoreApiPaymentAccountRepository: CoreApiRepository { }

extension CoreApiPaymentAccountRepository: PaymentAccountRepository {
    public func currentUserPaymentAccountsCount(params: CurrentUserPaymentAccountsCountParams,
                                                completion: @escaping CurrentUserPaymentAccountsCountHandler) {
        performTask(expecting: PaymentAccountCountDataTransferResponse.self, completion: completion) { requestBuilder in
            return requestBuilder
                .setBody(key: .req, value: "getPaymentAccountsCount")
        }
    }

    public func currentUserPaymentAccounts(params: CurrentUserPaymentAccountsPageParams,
                                           completion: @escaping CurrentUserPaymentAccountsHandler) {
        performTask(expecting: PaymentAccountDataTransferResponse.self, completion: completion) { requestBuilder in
            return requestBuilder
                .setBody(key: .req, value: "getPaymentAccounts")
                .setBody(key: "pageIndex", value: "\(params.pageIndex)")
                .setBody(key: "maxResult", value: "\(params.pageCount)")
        }
    }

    public func currentUserPaymentAccountDelete(params: CurrentUserPaymentAccountDeleteParams,
                                                completion: @escaping CurrentUserPaymentAccountDeleteHandler) {
        performTask(expecting: PaymentAccountDeleteDataTransferResponse.self, completion: completion) { requestBuilder -> CoreRequestBuilder in
            return requestBuilder
                .setBody(key: .req, value: "deletePaymentAccount")
                .setBody(key: "paymentAccountID", value: "\(params.id)")
        }
    }
}
