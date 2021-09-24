//
//  MobileApiFAQRepository.swift
//  Mobile
//
//  Created by Nika Chkadua on 22.09.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

public class DefaultFAQRepository: FAQRepository {
    @Inject private var dataTransferService: DataTransferService
    private var requestBuilder: HttpRequestBuilder { HttpRequestBuilderImpl.createInstance() }
    @Inject private var languageStorage: LanguageStorage

    func getList(handler: @escaping FAQHandler) {
        let request = self.requestBuilder
            .set(host: "https://mobileapi.adjarabet.com/faq?language=\(languageStorage.currentLanguage.mobileApiLocalizableIdentifier)")
            .set(method: HttpMethodGet())
            .build()

        dataTransferService.performTask(expecting: FAQDTO.self,
                                        request: request,
                                        respondOnQueue: .main,
                                        completion: handler)
    }
}
