//
//  MobileApiContact.swift
//  Mobile
//
//  Created by Nika Chkadua on 24.09.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

public class DefaultContactRepository: ContactRepository {
    @Inject private var dataTransferService: DataTransferService
    private var requestBuilder: HttpRequestBuilder { HttpRequestBuilderImpl.createInstance() }
    @Inject private var languageStorage: LanguageStorage

    func getContactInfo(handler: @escaping ContactInfoHandler) {
        let request = self.requestBuilder
            .set(host: "https://mobileapi.adjarabet.com/contacts?domain=\("com")&language=\(languageStorage.currentLanguage.mobileApiLocalizableIdentifier)")
            .set(method: HttpMethodGet())
            .build()

        dataTransferService.performTask(expecting: ContactDTO.self,
                                        request: request,
                                        respondOnQueue: .main,
                                        completion: handler)
    }
}
