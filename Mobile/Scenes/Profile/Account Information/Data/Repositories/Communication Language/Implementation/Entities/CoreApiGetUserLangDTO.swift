//
//  CoreApiGetUserLangDTO.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 6/17/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

struct CoreApiGetUserLangDTO: CoreDataTransferResponse {
    struct Body: CoreStatusCodeable {
        let statusCode: Int
        let language: String?

        enum CodingKeys: String, CodingKey {
            case statusCode = "StatusCode"
            case language = "Lang"
        }
    }

    typealias Entity = CommunicationLanguageEntity

    static func entitySafely(header: DataTransferResponseDefaultHeader, body: Body) -> Result<Entity, ABError>? {
        guard let coreLanguage = body.language,
              let language = CommunicationLanguageEntity(coreLanguage: coreLanguage)
        else { return nil }
        return .success(language)
    }
}

fileprivate extension CommunicationLanguageEntity {
    init?(coreLanguage: String) {
        switch coreLanguage {
        case "ge":  self = .georgian
        case "en":  self = .english
        case "ru":  self = .russian
        default: return nil
        }
    }
}
