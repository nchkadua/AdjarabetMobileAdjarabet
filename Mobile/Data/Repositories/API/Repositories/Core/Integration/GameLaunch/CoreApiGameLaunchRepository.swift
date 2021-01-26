//
//  CoreApiGameLaunchRepository.swift
//  Mobile
//
//  Created by Nika Chkadua on 12/10/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

public class CoreApiGameLaunchRepository {
    @Inject private var userSession: UserSessionServices
    @Inject private var dataTransferService: DataTransferService
    private var requestBuilder: CoreRequestBuilder { CoreRequestBuilder() }
}

extension CoreApiGameLaunchRepository: GameLaunchRepository {
    public func getServiceAuthToken(params: AuthTokenParams, completion: @escaping AuthTokenHandler) {
        guard let sessionId = userSession.sessionId,
              let userId = userSession.userId
        else {
            // TODO: completion(.failure("no session id or user id found"))
            return
        }

        let request = requestBuilder
            .setHeader(key: .cookie, value: sessionId)
            .setBody(key: .req, value: "getServiceAuthToken")
            .setBody(key: .userId, value: "\(userId)")
            .setBody(key: "providerID", value: params.providerId)
            .build()

        dataTransferService.performTask(expecting: AuthTokenDataTransferResponse.self, request: request, respondOnQueue: .main, completion: completion)
    }
}
