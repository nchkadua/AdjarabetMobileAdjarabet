//
//  TBCRegularPaymentsRepository.swift
//  Mobile
//
//  Created by Nika Chkadua on 3/4/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

protocol TBCRegularPaymentsRepository {
    // MARK: Deposit
    typealias InitDepositHandler = (Result<UFCInitDepositEntity, Error>) -> Void
    func initDeposit(params: Params,
                     handler: @escaping InitDepositHandler)

    typealias DepositHandler = (Result<UFCDepositEntity, Error>) -> Void
    func deposit(params: Params,
                 handler: @escaping DepositHandler)

    // MARK: Withdraw
    typealias InitWithdrawHandler = (Result<UFCInitWithdrawEntity, Error>) -> Void
    func initWithdraw(params: Params,
                      handler: @escaping InitWithdrawHandler)

    typealias WithdrawHandler = (Result<TBCRegularPaymentsWithdrawEntity, Error>) -> Void
    func withdraw(params: Params,
                      handler: @escaping WithdrawHandler)
}

struct Params {
    let providerId = "c47e7151-a66f-4430-9c2d-adb656c14bb6"
    let serviceName = "ufc"
    let serviceId = 1030
    let saveForRecurring = 1
    let amount: Double
    var accountId: Int64?
    var session: String?
}

struct DefaultTBCRegularPaymentsRepository: TBCRegularPaymentsRepository {
    @Inject private var userSession: UserSessionReadableServices
    @Inject private var languageStorage: LanguageStorage
    private var httpRequestBuilder: HttpRequestBuilder { HttpRequestBuilderImpl.createInstance() }
    private var dataTransferService: DataTransferService { DefaultDataTransferService() }

    // MARK: Deposit
    func initDeposit(params: Params, handler: @escaping InitDepositHandler) {
        guard let sessionId = userSession.sessionId,
              let userId = userSession.userId,
              let currencyId = userSession.currencyId,
              let currency = Currency(currencyId: currencyId)
        else {
            handler(.failure(AdjarabetCoreClientError.sessionUninitialzed))
            return
        }

        var body: [String: Any] = [
            "op_type": "initDeposit",
            "user_id": userId,
            "provider_id": params.providerId,
            "service_name": params.serviceName,
            "service_id": params.serviceId,
            "currency": currency.description.abbreviation,
            "save_for_recurring": params.saveForRecurring,
            "amount": "\(params.amount)"
        ]

        if let accountId = params.accountId {
            body["account_id"] = "\(accountId)"
        }

        let headers = [
            "Cookie": sessionId,
            "Origin": AppConstant.coreOriginDomain,
            "Referer": AppConstant.coreOriginDomain,
            "X-Requested-With": "XMLHttpRequest"
        ]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: body, options: []), let jsonStr = String(data: jsonData, encoding: .ascii) else { return }

        let request = httpRequestBuilder
            .set(host: "https://coreapi.adjarabet.com/AuthenticationProxy")
            .set(headers: headers)
            .set(method: HttpMethodPost())
            .set(contentType: ContentTypeUrlEncoded())
            .setBody(key: "data", value: jsonStr)
            .setBody(key: "req", value: "initDeposit")
            .build()

        dataTransferService.performTask(expecting: UFCInitDepositDTO.self,
                                        request: request,
                                        respondOnQueue: .main,
                                        completion: handler)
    }

    func deposit(params: Params, handler: @escaping DepositHandler) {
        guard let sessionId = userSession.sessionId,
              let userId = userSession.userId,
              let currencyId = userSession.currencyId,
              let currency = Currency(currencyId: currencyId)
        else {
            handler(.failure(AdjarabetCoreClientError.sessionUninitialzed))
            return
        }

        var body: [String: Any] = [
            "op_type": "Deposit",
            "user_id": userId,
            "provider_id": params.providerId,
            "service_name": params.serviceName,
            "service_id": params.serviceId,
            "currency": currency.description.abbreviation,
            "save_for_recurring": params.saveForRecurring,
            "lang": languageStorage.currentLanguage.localizableIdentifier,
            "amount": "\(params.amount)",
            "session": params.session ?? ""
        ]

        if let accountId = params.accountId {
            body["account_id"] = "\(accountId)"
        }

        let headers = [
            "Cookie": sessionId,
            "Origin": AppConstant.coreOriginDomain,
            "Referer": AppConstant.coreOriginDomain,
            "X-Requested-With": "XMLHttpRequest"
        ]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: body, options: []), let jsonStr = String(data: jsonData, encoding: .ascii) else { return }

        let request = httpRequestBuilder
            .set(host: "https://coreapi.adjarabet.com/AuthenticationProxy")
            .set(headers: headers)
            .set(method: HttpMethodPost())
            .set(contentType: ContentTypeUrlEncoded())
            .setBody(key: "data", value: jsonStr)
            .setBody(key: "req", value: "Deposit")
            .build()

        dataTransferService.performTask(expecting: UFCDepositDTO.self,
                                        request: request,
                                        respondOnQueue: .main,
                                        completion: handler)
    }

    // MARK: Withdraw
    func initWithdraw(params: Params, handler: @escaping InitWithdrawHandler) {
        guard let sessionId = userSession.sessionId,
              let userId = userSession.userId,
              let currencyId = userSession.currencyId,
              let currency = Currency(currencyId: currencyId)
        else {
            handler(.failure(AdjarabetCoreClientError.sessionUninitialzed))
            return
        }

        var body: [String: Any] = [
            "op_type": "initWithdraw",
            "user_id": userId,
            "provider_id": params.providerId,
            "service_name": params.serviceName,
            "service_id": params.serviceId,
            "currency": currency.description.abbreviation,
            "amount": "\(params.amount)"
        ]

        if let accountId = params.accountId {
            body["account_id"] = "\(accountId)"
        }

        let headers = [
            "Cookie": sessionId,
            "Origin": AppConstant.coreOriginDomain,
            "Referer": AppConstant.coreOriginDomain,
            "X-Requested-With": "XMLHttpRequest"
        ]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: body, options: []), let jsonStr = String(data: jsonData, encoding: .ascii) else { return }

        let request = httpRequestBuilder
            .set(host: "https://coreapi.adjarabet.com/AuthenticationProxy")
            .set(headers: headers)
            .set(method: HttpMethodPost())
            .set(contentType: ContentTypeUrlEncoded())
            .setBody(key: "data", value: jsonStr)
            .setBody(key: "req", value: "initWithdraw")
            .build()

        dataTransferService.performTask(expecting: UFCInitWithdrawDTO.self,
                                        request: request,
                                        respondOnQueue: .main,
                                        completion: handler)
    }

    func withdraw(params: Params, handler: @escaping WithdrawHandler) {
        guard let sessionId = userSession.sessionId,
              let userId = userSession.userId,
              let currencyId = userSession.currencyId,
              let currency = Currency(currencyId: currencyId)
        else {
            handler(.failure(AdjarabetCoreClientError.sessionUninitialzed))
            return
        }

        var body: [String: Any] = [
            "op_type": "withdraw",
            "user_id": userId,
            "provider_id": params.providerId,
            "service_name": params.serviceName,
            "service_id": params.serviceId,
            "currency": currency.description.abbreviation,
            "save_for_recurring": params.saveForRecurring,
            "lang": languageStorage.currentLanguage.localizableIdentifier,
            "amount": "\(params.amount)",
            "session": params.session ?? ""
        ]

        if let accountId = params.accountId {
            body["account_id"] = "\(accountId)"
        }

        let headers = [
            "Cookie": sessionId,
            "Origin": AppConstant.coreOriginDomain,
            "Referer": AppConstant.coreOriginDomain,
            "X-Requested-With": "XMLHttpRequest"
        ]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: body, options: []), let jsonStr = String(data: jsonData, encoding: .ascii) else { return }

        let request = httpRequestBuilder
            .set(host: "https://coreapi.adjarabet.com/AuthenticationProxy")
            .set(headers: headers)
            .set(method: HttpMethodPost())
            .set(contentType: ContentTypeUrlEncoded())
            .setBody(key: "data", value: jsonStr)
            .setBody(key: "req", value: "withdraw")
            .build()

        dataTransferService.performTask(expecting: TBCRegularPaymentWithdrawDTO.self,
                                        request: request,
                                        respondOnQueue: .main,
                                        completion: handler)
    }
}
