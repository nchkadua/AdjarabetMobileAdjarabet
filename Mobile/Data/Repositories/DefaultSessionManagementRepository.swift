//
//  DefaultSessionManagementRepository.swift
//  Mobile
//
//  Created by Shota Ioramashvili on 5/9/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

public class DefaultSessionManagementRepository {
    @Inject private var dataTransferService: DataTransferService
    @Inject private var requestBuilder: AdjarabetCoreClientRequestBuilder
}

extension DefaultSessionManagementRepository: SessionManagementRepository {
    public func aliveSession<T>(userId: Int, sessionId: String, completion: @escaping (Result<T, Error>) -> Void) -> Cancellable where T: AdjarabetCoreCodableType {
        let request = requestBuilder
            .set(method: .aliveSession)
            .set(userId: userId)
            .setHeader(key: .cookie, value: sessionId)
            .build()

        return dataTransferService.performTask(request: request, respondOnQueue: .main, completion: completion)
    }
}
