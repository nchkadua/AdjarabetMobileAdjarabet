//
//  CoreApiUpdateOtpRepository.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 7/3/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

struct CoreApiUpdateOtpRepository: CoreApiRepository { }

extension CoreApiUpdateOtpRepository: UpdateOtpRepository {
    func set(isEnabled: Bool,
             otp: String,
             _ handler: @escaping SetIsEnabledHandler) {
        performTask(expecting: CoreApiStatusCodeDTO.self, completion: handler) { requestBuilder in
            return requestBuilder
                .setBody(key: .req, value: "otpOnOff")
                .setBody(key: .otp, value: otp)
                .setBody(key: "otpOn", value: "\(isEnabled ? 1 : 0)")
        }
    }
}
