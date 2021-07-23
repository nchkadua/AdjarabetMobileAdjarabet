//
//  CommunicationLanguageRepository.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 6/17/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

// MARK: Repository
protocol CommunicationLanguageRepository: CommunicationLanguageReadableRepository,
                                          CommunicationLanguageWritableRepository { }

// MARK: - Readable Repository
protocol CommunicationLanguageReadableRepository {
    /**
     Returns current logged users communication language
     */
    typealias GetUserLanguageHandler = (Result<CommunicationLanguageEntity, ABError>) -> Void
    func getUserLang(handler: @escaping GetUserLanguageHandler)
}

// MARK: - Writable Repository
protocol CommunicationLanguageWritableRepository {
    /**
     Changes current logged users communication language
     with specified with *language* entity
     */
    typealias ChangeUserLanguageHandler = (Result<Void, ABError>) -> Void
    func changeUserLang(with language: CommunicationLanguageEntity,
                        code: String?, // = nil
                        handler: @escaping ChangeUserLanguageHandler)
}
