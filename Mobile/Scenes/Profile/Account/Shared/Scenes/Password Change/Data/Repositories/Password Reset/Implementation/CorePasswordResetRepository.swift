//
//  CorePasswordResetRepository.swift
//  Mobile
//
//  Created by Nika Chkadua on 6/16/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

struct CorePasswordResetRepository: CoreApiRepository {
    @Inject private var userSession: UserSessionReadableServices
}

extension CorePasswordResetRepository: PasswordResetRepository {
    func initPasswordReset(username: String?, handler: @escaping InitPasswordResetHandler) {
        guard let userName = userSession.username,
              let sessionId = userSession.sessionId
        else {
            handler(.failure(.sessionNotFound))
            return
        }

        let request = requestBuilder
            .setHeader(key: .cookie, value: sessionId)
            .setBody(key: .req, value: "initPasswordReset")
            .setBody(key: .userIdentifier, value: username ?? userName)
            .build()

        dataTransferService.performTask(expecting: InitPasswordResetDTO.self, request: request, respondOnQueue: .main, completion: handler)
    }

    func getPasswordResetCode(params: PasswordResetCodeParams, handler: @escaping GetPasswordResetCodeHandler) {
        guard let username = userSession.username,
              let sessionId = userSession.sessionId
        else {
            handler(.failure(.sessionNotFound))
            return
        }

        let request = requestBuilder
            .setHeader(key: .cookie, value: sessionId)
            .setBody(key: .req, value: "getPasswordResetCode")
            .setBody(key: .userIdentifier, value: params.username ?? username)
            .setBody(key: "address", value: params.address)
            .setBody(key: .channelType, value: String(params.channelType.rawValue))
            .build()

        dataTransferService.performTask(expecting: GetPasswordResetCodeDTO.self, request: request, respondOnQueue: .main, completion: handler)
    }

    func resetPassword(params: ResetPasswordParams, handler: @escaping ResetPasswordHandler) {
        guard let userID = userSession.userId,
              let sessionId = userSession.sessionId
        else {
            handler(.failure(.sessionNotFound))
            return
        }

        let request = requestBuilder
            .setHeader(key: .cookie, value: sessionId)
            .setBody(key: .req, value: "resetPassword")
            .setBody(key: .userId, value: params.userId ?? String(userID))
            .setBody(key: "confirmCode", value: params.confirmCode ?? "")
            .setBody(key: .newPassword, value: params.newPassword)
            .build()

        dataTransferService.performTask(expecting: ResetPasswordDTO.self, request: request, respondOnQueue: .main, completion: handler)
    }
}
