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
    let serviceName: String
    let amount: Double
    let saveForRecurring: Int
    let accountId: Int64? // if null add card service is called
    var session: String?  // if null is init method
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
    typealias InitDepositHandler = (Result<UFCInitDepositEntity, ABError>) -> Void
    // input
    func initDeposit(with params: UFCInitDepositParams, _ handler: @escaping InitDepositHandler)

    /**
     Performs Deposit Transaction
     */
    // output
    typealias DepositHandler = (Result<UFCDepositEntity, ABError>) -> Void
    // input
    func deposit(with params: UFCDepositParams, _ handler: @escaping DepositHandler)
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
    typealias InitWithdrawHandler = (Result<UFCInitWithdrawEntity, ABError>) -> Void
    // input
    func initWithdraw(with params: UFCInitWithdrawParams, _ handler: @escaping InitWithdrawHandler)

    /**
     Performs Withdraw Transaction
     */
    // output
    typealias WithdrawHandler = (Result<Void, ABError>) -> Void
    // input
    func withdraw(with params: UFCWithdrawParams, _ handler: @escaping WithdrawHandler)
}

// MARK: Deposit & Withdraw Repository
protocol UFCTransactionRepository: UFCDepositRepository, UFCWithdrawRepository { }

// MARK: - Implementation
struct DefaultUFCTransactionRepository: UFCTransactionRepository {
    @Inject private var userSession: UserSessionReadableServices
    @Inject private var languageStorage: LanguageStorage
    private var httpRequestBuilder: HttpRequestBuilder { HttpRequestBuilderImpl.createInstance() }
    private var dataTransferService: DataTransferService { DefaultDataTransferService() }

    func initDeposit(with params: UFCInitDepositParams, _ handler: @escaping InitDepositHandler) {
        transaction(operation: "initDeposit", with: params, expecting: UFCInitDepositDTO.self, handler)
    }

    func deposit(with params: UFCDepositParams, _ handler: @escaping DepositHandler) {
        transaction(operation: "Deposit", with: params, expecting: UFCDepositDTO.self, handler)
    }

    func initWithdraw(with params: UFCInitWithdrawParams, _ handler: @escaping InitWithdrawHandler) {
        transaction(operation: "initWithdraw", with: params, expecting: UFCInitWithdrawDTO.self, handler)
    }

    func withdraw(with params: UFCWithdrawParams, _ handler: @escaping WithdrawHandler) {
        transaction(operation: "withdraw", with: params, expecting: UFCWithdrawDTO.self, handler)
    }

    private func transaction<Response: DataTransferResponse> (
        operation: String,
        with params: UFCTransactionParams,
        expecting response: Response.Type,
        _ handler: @escaping (Result<Response.Entity, ABError>) -> Void
    ) {
        guard let sessionId = userSession.sessionId,
              let userId = userSession.userId,
              let currencyId = userSession.currencyId,
              let currency = Currency(currencyId: currencyId)
        else {
            handler(.failure(.sessionNotFound))
            return
        }

        var body: [String: Any] = [
            "op_type": operation,
            "user_id": userId,
            "provider_id": params.providerId,
            "service_id": params.serviceId,
            "service_name": params.serviceName,
            "currency": currency.description.abbreviation,
            "lang": languageStorage.currentLanguage.localizableIdentifier,
            "save_for_recurring": params.saveForRecurring,
            "amount": "\(params.amount)"
        ]

        if let accountId = params.accountId { // if null add card service is called
            body["account_id"] = "\(accountId)"
        }

        if let session = params.session { // if null is init method
            body["session"] = session
        }

        let headers = [
            "Cookie": sessionId,
            "Origin": AppConstant.coreOriginDomain,
            "Referer": AppConstant.coreOriginDomain,
            "X-Requested-With": "XMLHttpRequest"
        ]

        guard let dataJson = try? JSONSerialization.data(withJSONObject: body, options: []),
              let dataString = String(data: dataJson, encoding: .ascii)
        else {
            handler(.failure(.`init`(description: .init(description: "Request Parsing Error"))))
            return
        }

        let request = httpRequestBuilder
            .set(host: "https://coreapi.adjarabet.com/AuthenticationProxy")
            .set(headers: headers)
            .set(method: HttpMethodPost())
            .set(contentType: ContentTypeUrlEncoded())
            .setBody(key: "data", value: dataString)
            .setBody(key: "req", value: operation)
            .build()

        dataTransferService.performTask(expecting: response,
                                        request: request,
                                        respondOnQueue: .main,
                                        completion: handler)
    }
}
