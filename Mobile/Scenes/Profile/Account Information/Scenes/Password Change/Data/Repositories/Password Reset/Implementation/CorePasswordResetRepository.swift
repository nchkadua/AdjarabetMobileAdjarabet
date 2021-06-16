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
    func initPasswordReset(handler: @escaping InitPasswordResetHandler) {
        guard let username = userSession.username,
              let sessionId = userSession.sessionId
        else {
            handler(.failure(.sessionUninitialized))
            return
        }

        let request = requestBuilder
            .setHeader(key: .cookie, value: sessionId)
            .setBody(key: .req, value: "initPasswordReset")
            .setBody(key: .userIdentifier, value: username)
            .build()

        dataTransferService.performTask(expecting: InitPasswordResetDTO.self, request: request, respondOnQueue: .main, completion: handler)
    }
}
