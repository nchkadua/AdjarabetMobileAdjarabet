//
//  CoreApiIsOTPEnabledRepository.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 6/9/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

struct CoreApiIsOTPEnabledRepository: CoreApiRepository { }

extension CoreApiIsOTPEnabledRepository: IsOTPEnabledRepository {
    func isEnabled(_ handler: @escaping IsEnabledHandler) {
        performTask(expecting: CoreApiIsOTPEnabledDTO.self, completion: handler) { requestBuilder in
            return requestBuilder
                .setBody(key: .req, value: "isOTPEnabled")
        }
    }
}
