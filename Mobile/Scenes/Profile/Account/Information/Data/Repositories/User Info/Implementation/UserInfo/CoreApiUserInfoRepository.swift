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

    func getIDDocuments(handler: @escaping IDDocumentsHandler) {
        guard let userId = userSession.userId else {
            handler(.failure(.init(type: .sessionNotFound)))
            return
        }

        performTask(expecting: IDDocumentsDTO.self, completion: handler) { requestBuilder in
            return requestBuilder
                .setBody(key: .req, value: "getIDDocuments")
                .setBody(key: .userId, value: String(userId))
        }
    }
}
