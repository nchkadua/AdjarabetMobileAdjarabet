//
//  CoreApiCommunicationLanguageRepository.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 6/17/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

struct CoreApiCommunicationLanguageRepository: CoreApiRepository { }

extension CoreApiCommunicationLanguageRepository: CommunicationLanguageRepository {
    func getUserLang(handler: @escaping GetUserLanguageHandler) {
        performTask(expecting: CoreApiGetUserLangDTO.self, completion: handler) { requestBuilder in
            return requestBuilder
                .setBody(key: .req, value: "getUserLang")
        }
    }

    func changeUserLang(with language: CommunicationLanguageEntity,
                        code: String?,
                        handler: @escaping ChangeUserLanguageHandler) {
        performTask(expecting: CoreApiStatusCodeDTO.self, completion: handler) { requestBuilder in
            var requestBuilder = requestBuilder

            if let code = code {
                requestBuilder = requestBuilder
                    .setBody(key: .otp, value: code)
            }

            return requestBuilder
                .setBody(key: .req, value: "changeLang")
                .setBody(key: "langCode", value: language.coreLanguage)
        }
    }
}

fileprivate extension CommunicationLanguageEntity {
    var coreLanguage: String {
        switch self {
        case .georgian:  return "ge"
        case .english:   return "en"
        case .russian:   return "ru"
        }
    }
}
