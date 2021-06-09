//
//  IsOTPEnabledRepository.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 6/9/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

protocol IsOTPEnabledRepository {
    /**
     Returns
     true  - if OTP is enabled
     false - if OTP is NOT enabled
     */
    typealias IsEnabledHandler = (Result<Bool, Error>) -> Void
    func isEnabled(_ handler: @escaping IsEnabledHandler)
}
