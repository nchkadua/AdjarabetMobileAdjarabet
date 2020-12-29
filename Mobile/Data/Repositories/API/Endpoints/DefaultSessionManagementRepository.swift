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
    private var requestBuilder: CoreRequestBuilder { CoreRequestBuilder() }
}

extension DefaultSessionManagementRepository: SessionManagementRepository {
    public func aliveSession<T>(userId: Int, sessionId: String, completion: @escaping (Result<T, Error>) -> Void) -> Cancellable where T: HeaderProvidingCodableType {
        let request = requestBuilder
            .setHeader(key: .cookie, value: sessionId)
            .setBody(key: .req, value: "isSessionActive")
            .setBody(key: .userId, value: "\(userId)")
            .build()

        return dataTransferService.performTask(request: request, respondOnQueue: .main, completion: completion)
    }
}
