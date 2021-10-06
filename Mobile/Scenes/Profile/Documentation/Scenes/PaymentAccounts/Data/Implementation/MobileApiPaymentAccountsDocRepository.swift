//
//  MobileApiPaymentAccountsDocRepository.swift
//  Mobile
//
//  Created by Nika Chkadua on 06.10.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

public struct DefaultPaymentAccountsDocRepository: PaymentAccountsDocRepository {
    @Inject private var dataTransferService: DataTransferService
    private var requestBuilder: HttpRequestBuilder { HttpRequestBuilderImpl.createInstance() }
    @Inject private var languageStorage: LanguageStorage

    func getUrl(handler: @escaping PaymentAccountsDocHandler) {
        let request = self.requestBuilder
            .set(host: "https://mobileapi.adjarabet.com/documentation/payment-methods?language=\(languageStorage.currentLanguage.mobileApiLocalizableIdentifier)")
            .set(method: HttpMethodGet())
            .build()

        dataTransferService.performTask(expecting: PaymentAccountsDocDTO.self,
                                        request: request,
                                        respondOnQueue: .main,
                                        completion: handler)
    }
}
