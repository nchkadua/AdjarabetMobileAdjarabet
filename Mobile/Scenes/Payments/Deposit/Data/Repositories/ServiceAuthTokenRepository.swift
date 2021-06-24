//
//  ServiceAuthTokenRepository.swift
//  Mobile
//
//  Created by Nika Chkadua on 6/15/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

protocol ServiceAuthTokenRepository {
    typealias TokenHandler = (Result<String, ABError>) -> Void
    func token(providerId: String, handler: @escaping TokenHandler)
}

struct DefaultServiceAuthTokenRepository: ServiceAuthTokenRepository, CoreApiRepository {
    private var httpRequestBuilder: HttpRequestBuilder { HttpRequestBuilderImpl.createInstance() }
    @Inject private var userAgentProvider: UserAgentProvider
    @Inject private var userSession: UserSessionReadableServices
    @Inject private var languageStorage: LanguageStorage

    func token(providerId: String, handler: @escaping TokenHandler) {
        guard let userId = userSession.userId
        else {
            handler(.failure(.sessionUninitialized))
            return
        }

        performTask(expecting: ServiceAuthTokenDTO.self, completion: handler) { requestBuilder in
            return requestBuilder
                .setBody(key: .req, value: "getServiceAuthToken")
                .setBody(key: "providerID", value: providerId)
                .setBody(key: .userId, value: String(userId))
                .setBody(key: "cur_lang", value: languageStorage.currentLanguage.localizableIdentifier)
        }
    }
}
