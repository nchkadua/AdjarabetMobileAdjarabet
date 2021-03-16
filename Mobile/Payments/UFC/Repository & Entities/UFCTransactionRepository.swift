//
//  UFCTransactionRepository.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 3/16/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

/**
 General Parameters for UFC Transactions
 */
struct UFCTransactionParams {
    let providerId: String
    let serviceId: Int
    let amount: Double
    let serviceName: String
    let saveForRecurring: Bool
    let accountId: Int64? // if null add card service is called
    let session: String?  // if null is init method
}

// Init Deposit Parameters
typealias UFCInitDepositParams = UFCTransactionParams
// Deposit Parameters
typealias UFCDepositParams = UFCTransactionParams

// MARK: Deposit Repository
protocol UFCDepositRepository {
    /**
     Initializes Deposit Transaction:
     Returns Session ID for Transaction
     */
    // output
    typealias InitDepositHandler = (Result<UFCInitDepositEntity, Error>) -> Void
    // input
    func initDeposit(with params: UFCInitDepositParams, _ handler: InitDepositHandler)

    /**
     Performs Deposit Transaction
     */
    // output
    typealias DepositHandler = (Result<UFCDepositEntity, Error>) -> Void
    // input
    func deposit(with params: UFCDepositParams, _ handler: DepositHandler)
}

// Init Withdraw Parameters
typealias UFCInitWithdrawParams = UFCTransactionParams
// Withdraw Parameters
typealias UFCWithdrawParams = UFCTransactionParams

// MARK: Withdraw Repository
protocol UFCWithdrawRepository {
    /**
     Initializes Withdraw Transaction:
     Returns Session ID for Transaction
     */
    // output
    typealias InitWithdrawHandler = (Result<UFCInitWithdrawEntity, Error>) -> Void
    // input
    func initWithdraw(with params: UFCInitWithdrawParams, _ handler: InitWithdrawHandler)

    /**
     Performs Withdraw Transaction
     */
    // output
    typealias WithdrawHandler = (Result<UFCWithdrawEntity, Error>) -> Void
    // input
    func withdraw(with params: UFCWithdrawParams, _ handler: WithdrawHandler)
}

// MARK: - Implementation

// ...
