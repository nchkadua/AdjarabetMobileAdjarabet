//
//  PhoneVerificationCodeRepository.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 6/23/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

protocol PhoneVerificationCodeRepository {
    /**
     Sends Verification Code on phone number
     specified with *tel* property
     */
    typealias SendVerificationCodeHandler = (Result<Void, ABError>) -> Void
    func sendVerificationCode(with params: SendVerificationCodeParams,
                              handler: @escaping SendVerificationCodeHandler)
}

struct SendVerificationCodeParams {
    let tel: String
    let channelType: ChannelType
    let userLang: String         // FIXME: maybe change with enum also

    enum ChannelType: Int {
        case sms = 2
        case voiceCall = 4
    }
}
