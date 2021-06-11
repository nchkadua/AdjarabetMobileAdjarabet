//
//  CorePasswordChangeRepository.swift
//  Mobile
//
//  Created by Nika Chkadua on 6/11/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

struct CoreApiPasswordChangeRepository: CoreApiRepository {
    @Inject private var userSession: UserSessionReadableServices
}

extension CoreApiPasswordChangeRepository: PasswordChangeRepository {
    private var requestBuilder: HttpRequestBuilder { HttpRequestBuilderImpl.createInstance() }

    func change(params: PasswordChangeParams, handler: @escaping PasswordChangeHandler) {
        guard let userId = userSession.userId
        else {
            handler(.failure(AdjarabetCoreClientError.sessionUninitialzed))
            return
        }

        var request = requestBuilder
            .setBody(key: .req, value: "changePassword")
            .setBody(key: .userId, value: String(userId))
            .setBody(key: .oldPassword, value: params.oldPassword)
            .setBody(key: .newPassword, value: params.newPassword)

        if params.otp > -1 {
            request = request.setBody(key: .otp, value: String(params.otp))
        }

        performTask(expecting: PasswordChangeDTO.self, completion: handler) { _ in
            return request
        }
    }
}
