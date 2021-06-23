//
//  CoreApiContactInfoRepository.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 6/23/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

struct CoreApiContactInfoRepository: CoreApiRepository { }

extension CoreApiContactInfoRepository: ContactInfoRepository {
    func updateContactInfo(with params: UpdateContactInfoParams,
                           handler: @escaping UpdateContactInfoHandler) {
        performTask(expecting: CoreApiStatusCodeDTO.self, completion: handler) { requestBuilder in
            var requestBuilder = requestBuilder
                .setBody(key: .req, value: "updateContactInfo")
                .setBody(key: "pass", value: params.pass)

            if let otp = params.otp { // set otp if exists
                requestBuilder = requestBuilder
                    .setBody(key: "otp", value: otp)
            }

            if let email = params.email { // set email if exists
                requestBuilder = requestBuilder
                    .setBody(key: "email", value: email)
            }

            if let tel = params.tel,
               let newTelOtp = params.newTelOtp { // set tel and newTelOtp if exists
                requestBuilder = requestBuilder
                    .setBody(key: "tel", value: tel)
                    .setBody(key: "newTelOtp", value: newTelOtp)
            }

            return requestBuilder
        }
    }
}
