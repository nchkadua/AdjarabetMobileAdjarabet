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
    private var requestBuilder: AdjarabetCoreClientRequestBuilder { AdjarabetCoreClientRequestBuilder() }
}

extension DefaultBalanceManagementRepository: BalanceManagementRepository {
    public func balance<T: HeaderProvidingCodableType>(userId: Int, currencyId: Int, isSingle: Int, sessionId: String, completion: @escaping (Result<T, Error>) -> Void) -> Cancellable {
        let request = requestBuilder
            .set(method: .balance)
            .set(userId: userId, currencyId: currencyId, isSingle: isSingle)
            .setHeader(key: .cookie, value: sessionId)
            .build()

        return dataTransferService.performTask(request: request, respondOnQueue: .main, completion: completion)
    }
}
