//
//  MobileApiBonusesRepository.swift
//  Mobile
//
//  Created by Nika Chkadua on 30.09.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

struct DefaultBonusesRepository: BonusesRepository {
    @Inject private var dataTransferService: DataTransferService
    @Inject private var userSession: UserSessionReadableServices
    @Inject private var languageStorage: LanguageStorage
    private var requestBuilder: HttpRequestBuilder { HttpRequestBuilderImpl.createInstance() }

    func getActiveBonuses(pageIndex: Int, handler: @escaping ActiveBonusesHandler) {
        guard let userId = userSession.userId
        else {
            handler(.failure(.init(type: .sessionNotFound)))
            return
        }

        let request = self.requestBuilder
            .set(host: "https://mobileapi.adjarabet.com/bonus/active?userId=\(userId)&language=\(languageStorage.currentLanguage.mobileApiLocalizableIdentifier)&domain=\("com")&page=\(pageIndex)")
            .set(method: HttpMethodGet())
            .build()

        dataTransferService.performTask(expecting: ActiveBonusDTO.self,
                                        request: request,
                                        respondOnQueue: .main,
                                        completion: handler)
    }

    func getCompletedBonuses(pageIndex: Int, handler: @escaping CompletedBonusesHandler) {
        guard let userId = userSession.userId
        else {
            handler(.failure(.init(type: .sessionNotFound)))
            return
        }

        let request = self.requestBuilder
            .set(host: "https://mobileapi.adjarabet.com/bonus/completed?userId=\(userId)&language=\(languageStorage.currentLanguage.mobileApiLocalizableIdentifier)&domain=\("com")&page=\(pageIndex)")
            .set(method: HttpMethodGet())
            .build()

        dataTransferService.performTask(expecting: CompletedBonusDTO.self,
                                        request: request,
                                        respondOnQueue: .main,
                                        completion: handler)
    }
}
