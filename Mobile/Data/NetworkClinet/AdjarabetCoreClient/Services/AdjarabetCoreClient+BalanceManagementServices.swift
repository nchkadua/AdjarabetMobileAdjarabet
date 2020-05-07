//
//  AdjarabetCoreClient+BalanceManagementServices.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/12/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

extension AdjarabetCoreClient: BalanceManagementServices {
    public func balance<T: AdjarabetCoreCodableType>(userId: Int, currencyId: Int, isSingle: Int, sessionId: String, completion: @escaping (Result<T, Error>) -> Void) -> Cancellable {
        let request = standartRequestBuilder
            .set(method: .balance)
            .set(userId: userId, currencyId: currencyId, isSingle: isSingle)
            .setHeader(key: .cookie, value: sessionId)
            .build()

        return performTask(request: request, type: T.self, completion: completion)
    }
}
