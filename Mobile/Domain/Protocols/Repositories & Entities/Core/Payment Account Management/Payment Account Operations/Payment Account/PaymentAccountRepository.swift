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
     Returns count of payment accounts
     for the currently authenticated user
     */
    typealias CurrentUserPaymentAccountsCountHandler = (Result<PaymentAccountCount, Error>) -> Void
    func currentUserPaymentAccountsCount(params: CurrentUserPaymentAccountsCountParams,
                                         completion: @escaping CurrentUserPaymentAccountsCountHandler)

    /**
     Returns payment accounts and their details
     at specified 'pageIndex' and 'pageCount'
     for the currently authenticated user
     */
    typealias CurrentUserPaymentAccountsHandler = (Result<[PaymentAccountEntity], Error>) -> Void
    func currentUserPaymentAccounts(params: CurrentUserPaymentAccountsPageParams,
                                    completion: @escaping CurrentUserPaymentAccountsHandler)
}

// for currentUserPaymentAccountsCount
public struct CurrentUserPaymentAccountsCountParams { }

// for currentUserPaymentAccounts
public struct CurrentUserPaymentAccountsPageParams {
    public let pageIndex: Int
    public let pageCount: Int
}

// MARK: - Writable Repository
public protocol PaymentAccountWritableRepository { }
