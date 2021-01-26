//
//  PaymentAccountRepository.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 1/26/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

// MARK: Repository
public protocol PaymentAccountRepository: PaymentAccountReadableRepository,
                                          PaymentAccountWritableRepository { }

// MARK: - Readable Repository
public protocol PaymentAccountReadableRepository {
    /**
     Returns currently available all the payment accounts and
     their details for the currently authenticated user
     */
    typealias CurrentUserPaymentAccountsHandler = (Result<[PaymentAccountEntity], Error>) -> Void
    func currentUserPaymentAccounts(params: CurrentUserPaymentAccountsParams,
                                    completion: @escaping CurrentUserPaymentAccountsHandler)
}

// for currentUserPaymentAccounts
public struct CurrentUserPaymentAccountsParams {
    public let pageIndex: Int
    public let pageCount: Int
}

// MARK: - Writable Repository
public protocol PaymentAccountWritableRepository { }
