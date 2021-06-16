//
//  ResetPasswordUseCase.swift
//  Mobile
//
//  Created by Nika Chkadua on 6/16/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

protocol ResetPasswordUseCase {
    typealias InitPasswordResetHandler = (Result<InitPasswordResetEntity, ABError>) -> Void
    func initPasswordReset(handler: @escaping InitPasswordResetHandler)
}

struct DefaultResetPasswordUseCase: ResetPasswordUseCase {
    @Inject(from: .repositories) private var repo: PasswordResetRepository

    func initPasswordReset(handler: @escaping InitPasswordResetHandler) {
        repo.initPasswordReset(handler: handler)
    }
}
