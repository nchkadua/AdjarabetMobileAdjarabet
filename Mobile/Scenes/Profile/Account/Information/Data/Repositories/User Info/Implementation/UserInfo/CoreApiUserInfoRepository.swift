//
//  CoreApiUserInfoRepository.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 11/26/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

struct CoreApiUserInfoRepository: CoreApiRepository { }

extension CoreApiUserInfoRepository: UserInfoRepository {
    func currentUserInfo(params: CurrentUserInfoParams, completion: @escaping CurrentUserInfoHandler) {
        performTask(expecting: UserInfoDataTransferResponse.self, completion: completion) { requestBuilder in
            return requestBuilder
                .setBody(key: .req, value: "getUserInfo")
        }
    }

    func getIDDocuments(params: IdDocumentsParams, handler: @escaping IDDocumentsHandler) {
        guard let userId = params.userId,
              let sessionId = params.header else {
            handler(.failure(.init(type: .sessionNotFound)))
            return
        }

        let request = requestBuilder
            .setHeader(key: .cookie, value: params.header ?? sessionId)
            .setBody(key: .req, value: "getIDDocuments")
            .setBody(key: .userId, value: params.userId ?? String(userId))
            .build()

        dataTransferService.performTask(expecting: IDDocumentsDTO.self, request: request, respondOnQueue: .main, completion: handler)
    }
}
