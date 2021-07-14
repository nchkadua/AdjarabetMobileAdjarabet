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
    func initPasswordReset(username: String?, handler: @escaping InitPasswordResetHandler)

    typealias GetPasswordResetCodeHandler = (Result<GetPasswordResetCodeEntity, ABError>) -> Void
    func getPasswordResetCode(params: PasswordResetCodeParams, handler: @escaping GetPasswordResetCodeHandler)

    typealias ResetPasswordHandler = (Result<ResetPasswordEntity, ABError>) -> Void
    func resetPassword(params: ResetPasswordParams, handler: @escaping ResetPasswordHandler)
}

public struct PasswordResetCodeParams {
    let address: String
    let channelType: OTPDeliveryChannel
}

public struct ResetPasswordParams {
    let confirmCode: String
    let newPassword: String
}

struct DefaultResetPasswordUseCase: ResetPasswordUseCase {
    @Inject(from: .repositories) private var repo: PasswordResetRepository
    @Inject private var userSession: UserSessionServices
    @Inject private var userSessionReadable: UserSessionReadableServices

    func initPasswordReset(username: String?, handler: @escaping InitPasswordResetHandler) {
        repo.initPasswordReset(username: username, handler: handler)
    }

    func getPasswordResetCode(params: PasswordResetCodeParams, handler: @escaping GetPasswordResetCodeHandler) {
        repo.getPasswordResetCode(params: params, handler: handler)
    }

    func resetPassword(params: ResetPasswordParams, handler: @escaping ResetPasswordHandler) {
        repo.resetPassword(params: params) { result in
            switch result {
            case .success(let entity):
                save(password: params.newPassword)
                handler(.success(entity))
            case .failure(let error): handler(.failure(error))
            }
        }
    }

    private func save(password: String) {
        userSession.set(userId: userSessionReadable.userId ?? -1,
                        username: userSessionReadable.username ?? "",
                        sessionId: userSessionReadable.sessionId ?? "",
                        currencyId: userSessionReadable.currencyId,
                        password: password)
    }
}
