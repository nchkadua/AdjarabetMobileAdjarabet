//
//  DefaultBalanceManagementRepository.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 5/9/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

public class DefaultBalanceManagementRepository {
    @Inject private var dataTransferService: DataTransferService
    private var requestBuilder: CoreRequestBuilder { CoreRequestBuilder() }
}

extension DefaultBalanceManagementRepository: BalanceManagementRepository {
    public func balance<T: HeaderProvidingCodableType>(userId: Int, currencyId: Int, isSingle: Int, sessionId: String, completion: @escaping (Result<T, Error>) -> Void) -> Cancellable {
        let request = requestBuilder
            .setHeader(key: .cookie, value: sessionId)
            .setBody(key: .req, value: "getBalance")
            .setBody(key: .userId, value: "\(userId)")
            .setBody(key: .currencyId, value: "\(currencyId)")
            .setBody(key: .isSingle, value: "\(isSingle)")
            .build()

        return dataTransferService.performTask(request: request, respondOnQueue: .main, completion: completion)
    }
}
