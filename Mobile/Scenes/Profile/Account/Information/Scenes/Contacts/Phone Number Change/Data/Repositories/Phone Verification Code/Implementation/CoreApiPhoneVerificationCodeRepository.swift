//
//  CoreApiPhoneVerificationCodeRepository.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 6/23/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

struct CoreApiPhoneVerificationCodeRepository: CoreApiRepository { }

extension CoreApiPhoneVerificationCodeRepository: PhoneVerificationCodeRepository {
    func sendVerificationCode(with params: SendVerificationCodeParams,
                              handler: @escaping SendVerificationCodeHandler) {
        let request = requestBuilder
            .setBody(key: .req, value: "getTelVerificationCode")
            .setBody(key: "tel", value: params.tel)
            .setBody(key: "channelType", value: "\(params.channelType.rawValue)")
            .setBody(key: "userLang", value: params.userLang)
            .build()

        dataTransferService.performTask(
            expecting: CoreApiSendVerificationCodeDTO.self,
            request: request,
            respondOnQueue: .main,
            completion: handler
        )
    }
}
