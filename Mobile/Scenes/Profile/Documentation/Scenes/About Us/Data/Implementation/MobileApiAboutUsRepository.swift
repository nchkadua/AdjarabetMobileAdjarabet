//
//  MobileApiAboutUsRepository.swift
//  Mobile
//
//  Created by Nika Chkadua on 27.09.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

public class DefaultAboutUsRepository: AboutUsRepository {
    @Inject private var dataTransferService: DataTransferService
    private var requestBuilder: HttpRequestBuilder { HttpRequestBuilderImpl.createInstance() }
    @Inject private var languageStorage: LanguageStorage

    func getUrl(handler: @escaping AboutUsHandler) {
        let request = self.requestBuilder
            .set(host: "https://mobileapi.adjarabet.com/documentation/about-us?language=\(languageStorage.currentLanguage.mobileApiLocalizableIdentifier)")
            .set(method: HttpMethodGet())
            .build()

        dataTransferService.performTask(expecting: MobileApiAboutUsDTO.self,
                                        request: request,
                                        respondOnQueue: .main,
                                        completion: handler)
    }
}
