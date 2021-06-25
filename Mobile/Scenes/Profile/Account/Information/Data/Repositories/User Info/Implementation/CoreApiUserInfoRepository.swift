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
}
