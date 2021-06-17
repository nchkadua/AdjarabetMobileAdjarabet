//
//  CoreApiActionOTPRepository.swift
//  Mobile
//
//  Created by Nika Chkadua on 6/10/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

struct CoreApiActionOTPRepository: CoreApiRepository {
    @Inject private var userSession: UserSessionReadableServices
}

extension CoreApiActionOTPRepository: ActionOTPRepository {
    private var requestBuilder: HttpRequestBuilder { HttpRequestBuilderImpl.createInstance() }

    func actionOTP(handler: @escaping ActionOTPHandler) {
        guard let userId = userSession.userId
        else {
            handler(.failure(.sessionNotFound))
            return
        }

        performTask(expecting: ActionOTPDTO.self, completion: handler) { requestBuilder in
            return requestBuilder
                .setBody(key: .req, value: "getActionOTP")
                .setBody(key: .userId, value: String(userId))
                .setBody(key: .channelType, value: String(OTPDeliveryChannel.sms.rawValue))
        }
    }
}
