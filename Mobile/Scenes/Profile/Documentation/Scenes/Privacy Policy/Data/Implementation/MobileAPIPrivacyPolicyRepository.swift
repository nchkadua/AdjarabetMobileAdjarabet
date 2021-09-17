//
//  MobileAPIPrivacyPolicyRepository.swift
//  Mobile
//
//  Created by Nika Chkadua on 13.09.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

public class DefaultPrivacyPolicyRepository: PrivacyPolicyRepository {
    @Inject private var dataTransferService: DataTransferService
    private var requestBuilder: HttpRequestBuilder { HttpRequestBuilderImpl.createInstance() }
    @Inject private var languageStorage: LanguageStorage

    func getUrl(handler: @escaping PrivacyPolicyHandler) {
        let request = self.requestBuilder
            .set(host: "https://mobileapi.adjarabet.com/documentation/privacy-policy?language=\(languageStorage.currentLanguage.mobileApiLocalizableIdentifier)")
            .set(method: HttpMethodGet())
            .build()

        dataTransferService.performTask(expecting: PrivacyPolicyDTO.self,
                                        request: request,
                                        respondOnQueue: .main,
                                        completion: handler)
    }
}
