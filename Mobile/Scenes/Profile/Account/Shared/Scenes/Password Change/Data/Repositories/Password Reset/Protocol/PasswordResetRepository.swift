//
//  PasswordResetRepository.swift
//  Mobile
//
//  Created by Nika Chkadua on 6/16/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

protocol PasswordResetRepository {
    /* Init Password - First step for getting verified list of communications */
    typealias InitPasswordResetHandler = (Result<InitPasswordResetEntity, ABError>) -> Void
    func initPasswordReset(username: String?, handler: @escaping InitPasswordResetHandler)

    /* Get password reset code */
    typealias GetPasswordResetCodeHandler = (Result<GetPasswordResetCodeEntity, ABError>) -> Void
    func getPasswordResetCode(params: PasswordResetCodeParams, handler: @escaping GetPasswordResetCodeHandler)

    /* Reset password */
    typealias ResetPasswordHandler = (Result<ResetPasswordEntity, ABError>) -> Void
    func resetPassword(params: ResetPasswordParams, handler: @escaping ResetPasswordHandler)
}
