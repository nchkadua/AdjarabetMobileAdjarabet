//
//  CoreApiSuspendRepository.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 6/23/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

struct CoreApiSuspendRepository: CoreApiRepository { }

extension CoreApiSuspendRepository: SuspendRepository {
    func suspend(with params: SuspendParams, handler: @escaping SuspendHandler) {
        performTask(expecting: CoreApiStatusCodeDTO.self, completion: handler) { requestBuilder in
            var requestBuilder = requestBuilder
                .setBody(key: .req, value: "suspendSelf")
                .setBody(key: "limitPeriod", value: "\(params.limitPeriod.value)")
                .setBody(key: "note", value: params.note)

            if let otp = params.otp {
                requestBuilder = requestBuilder
                    .setBody(key: "otp", value: otp)
            }

            return requestBuilder
        }
    }
}

fileprivate extension SuspendDuration {
    var value: Int {
        switch self {
        case .oneDay:    return 0
        case .twoDays:   return 1
        case .threeDays: return 2
        }
    }
}
