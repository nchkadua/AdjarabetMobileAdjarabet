//
//  CoreApiUserProfileRepository.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 11/26/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

public class CoreApiUserProfileRepository {
    @Inject private var userSession: UserSessionServices
    @Inject private var dataTransferService: DataTransferService
    private var requestBuilder: AdjarabetCoreClientRequestBuilder { AdjarabetCoreClientRequestBuilder() }
}

extension CoreApiUserProfileRepository: UserProfileRepository {
    public func currentUserInfo<T>(
        params: CurrentUserInfoParams,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> Cancellable? where T: HeaderProvidingCodableType {
        guard let sessionId = userSession.sessionId,
              let userId = userSession.userId
        else {
            // TODO: completion(.failure("no session id or user id found"))
            return nil
        }

        let request = requestBuilder
            .setHeader(key: .cookie, value: sessionId)
            .set(method: .currentUserInfo)
            .set(userId: userId)
            .build()

        return dataTransferService.performTask(request: request, respondOnQueue: .main, completion: completion)
    }
}
