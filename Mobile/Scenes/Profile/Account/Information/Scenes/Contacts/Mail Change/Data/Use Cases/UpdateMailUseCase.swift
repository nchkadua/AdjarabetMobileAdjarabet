//
//  UpdateMailUseCase.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 6/23/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

protocol UpdateMailUseCase {
    typealias Handler = (Result<Void, ABError>) -> Void
    func execute(with params: UpdateMailUseCaseParams,
                 handler: @escaping Handler)
}

struct UpdateMailUseCaseParams {
    let pass: String  // users' password
    let email: String // for updating e-mail
    let otp: String?  // if high security is enabled
}

// MARK: - Default Implementation

struct DefaultUpdateMailUseCase: UpdateMailUseCase {
    @Inject(from: .repositories) private var repo: ContactInfoRepository

    func execute(with params: UpdateMailUseCaseParams,
                 handler: @escaping Handler) {
        repo.updateContactInfo(
            with: .init(
                pass: params.pass,
                otp: params.otp,
                email: params.email,
                tel: nil,
                newTelOtp: nil
            ),
            handler: handler
        )
    }
}
