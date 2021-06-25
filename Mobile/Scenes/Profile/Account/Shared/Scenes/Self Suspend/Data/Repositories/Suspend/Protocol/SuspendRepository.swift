//
//  SuspendRepository.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 6/23/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

protocol SuspendRepository {
    typealias SuspendHandler = (Result<Void, ABError>) -> Void
    func suspend(with params: SuspendParams, handler: @escaping SuspendHandler)
}

struct SuspendParams {
    let limitPeriod: SuspendDuration
    let note: String
    let otp: String? // if high security is enabled
}
