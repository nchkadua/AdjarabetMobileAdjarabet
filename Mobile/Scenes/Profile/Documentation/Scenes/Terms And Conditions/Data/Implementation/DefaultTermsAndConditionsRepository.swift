//
//  MobileApiTermsAndConditionsRepository.swift
//  Mobile
//
//  Created by Giga Khizanishvili on 16.09.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

public class DefaultTermsAndConditionsRepository: TermsAndConditionsRepository {
	@Inject private var dataTransferService: DataTransferService
	private var requestBuilder: HttpRequestBuilder { HttpRequestBuilderImpl.createInstance() }
	@Inject private var languageStorage: LanguageStorage
	
	func execute(handler: @escaping TermsAndConditionsHandler) {
		let request = self.requestBuilder
			.set(host: "https://mobileapi.adjarabet.com/documentation/terms-and-conditions")
			.set(urlParams: ["language": languageStorage.currentLanguage.key])
			.set(method: HttpMethodGet())
			.build()
		
		print("*** DefaultTermsAndConditionsRepository.performTask")
		dataTransferService.performTask(expecting: TermsAndConditionsDTO.self,
										request: request,
										respondOnQueue: .main,
										completion: handler)
	}
}
