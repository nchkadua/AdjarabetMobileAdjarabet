//
//  CoreApiUserProfileRepository.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 11/26/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

public class CoreApiUserProfileRepository {
    public static let shared = CoreApiUserProfileRepository()
    @Inject private var userSession: UserSessionServices
    @Inject private var dataTransferService: DataTransferService
    private var requestBuilder: CoreRequestBuilder { CoreRequestBuilder() }
}

extension CoreApiUserProfileRepository: UserProfileRepository {
    public func currentUserInfo(params: CurrentUserInfoParams, completion: @escaping CurrentUserInfoHandler) {
        guard let sessionId = userSession.sessionId,
              let userId = userSession.userId
        else {
            // TODO: completion(.failure("no session id or user id found"))
            return
        }

        let request = requestBuilder
            .setHeader(key: .cookie, value: sessionId)
            .setBody(key: .req, value: "getUserInfo")
            .setBody(key: .userId, value: "\(userId)")
            .build()

        dataTransferService.performTask(expecting: UserInfoDataTransferResponse.self,
                                        request: request, respondOnQueue: .main, completion: completion)
    }
}
