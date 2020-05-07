//
//  AdjarabetCoreClient+SessionManagementServices.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 4/12/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

extension AdjarabetCoreClient: SessionManagementServices {
    public func aliveSession<T: AdjarabetCoreCodableType>(userId: Int, sessionId: String, completion: @escaping (Result<T, Error>) -> Void) -> Cancellable {
        let request = standartRequestBuilder
            .set(method: .aliveSession)
            .set(userId: userId)
            .setHeader(key: .cookie, value: sessionId)
            .build()

        return performTask(request: request, type: T.self, completion: completion)
    }
}
