//
//  HighSecurityUseCase.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 7/2/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

protocol HighSecurityUseCase {
    typealias IsEnabledHandler = (Result<Bool, ABError>) -> Void
    func isEnabled(_ handler: @escaping IsEnabledHandler)

    typealias SetIsEnabledHandler = (Result<Void, ABError>) -> Void
    func set(isEnabled: Bool,
             otp: String,
             _ handler: @escaping SetIsEnabledHandler)
}

// MARK: - Default Implementation
struct DefaultHighSecurityUseCase: HighSecurityUseCase {
    @Inject(from: .repositories) private var isEnabledRepo: IsOTPEnabledRepository
    @Inject(from: .repositories) private var updateOtpRepo: UpdateOtpRepository

    func isEnabled(_ handler: @escaping IsEnabledHandler) {
        isEnabledRepo.isEnabled(handler)
    }

    func set(isEnabled: Bool,
             otp: String,
             _ handler: @escaping SetIsEnabledHandler) {
        updateOtpRepo.set(isEnabled: isEnabled, otp: otp, handler)
    }
}
