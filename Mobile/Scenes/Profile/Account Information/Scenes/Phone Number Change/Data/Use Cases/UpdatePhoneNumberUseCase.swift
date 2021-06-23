//
//  UpdatePhoneNumberUseCase.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 6/23/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

protocol UpdatePhoneNumberUseCase {
    typealias Handler = (Result<Void, ABError>) -> Void
    func execute(with params: UpdatePhoneNumberUseCaseParams,
                 handler: @escaping Handler)
}

struct UpdatePhoneNumberUseCaseParams {
    let pass: String      // users' password
    let tel: String       // for updating tel
    let newTelOtp: String
    let otp: String?      // if high security is enabled
}

// MARK: - Default Implementation

struct DefaultUpdatePhoneNumberUseCase: UpdatePhoneNumberUseCase {
    @Inject(from: .repositories) private var repo: ContactInfoRepository

    func execute(with params: UpdatePhoneNumberUseCaseParams,
                 handler: @escaping Handler) {
        repo.updateContactInfo (
            with: .init (
                pass: params.pass,
                otp: params.otp,
                email: nil,
                tel: params.tel,
                newTelOtp: params.newTelOtp
            ),
            handler: handler
        )
    }
}
