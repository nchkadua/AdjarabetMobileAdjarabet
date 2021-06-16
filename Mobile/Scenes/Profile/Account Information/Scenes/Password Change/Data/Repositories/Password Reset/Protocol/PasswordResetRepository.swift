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
    func initPasswordReset(handler: @escaping InitPasswordResetHandler)
}
