//
//  UpdateOtpRepository.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 7/3/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

protocol UpdateOtpRepository {
    typealias SetIsEnabledHandler = (Result<Void, ABError>) -> Void
    func set(isEnabled: Bool,
             otp: String,
             _ handler: @escaping SetIsEnabledHandler)
}
