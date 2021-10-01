//
//  MobileApiPublicPromosRepository.swift
//  Mobile
//
//  Created by Nika Chkadua on 30.09.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

public struct DefaultPublicPromosRepository: PublicPromosRepository {
    @Inject private var dataTransferService: DataTransferService
    @Inject private var userSession: UserSessionReadableServices
    @Inject private var languageStorage: LanguageStorage
    private var httpRequestBuilder: HttpRequestBuilder { HttpRequestBuilderImpl.createInstance() }

    func getPromos(segmentList: [String], handler: @escaping PublicPromosHandler) {
        guard let userId = userSession.userId
        else {
            handler(.failure(.init(type: .sessionNotFound)))
            return
        }

        let body: [String: Any] = [
            "userId": "\(userId)",
            "segmentList": segmentList,
            "domain": "com", // TODO change to dynamic domain
            "language": languageStorage.currentLanguage.mobileApiLocalizableIdentifier
        ]

        let request = httpRequestBuilder
            .set(host: "https://mobileapi.adjarabet.com/promotions/public")
            .set(method: HttpMethodPost())
            .set(contentType: ContentTypeJson())
            .setBody(json: body)
            .build()

        dataTransferService.performTask(expecting: PublicPromosDTO.self,
                                        request: request,
                                        respondOnQueue: .main,
                                        completion: handler)
    }
}
