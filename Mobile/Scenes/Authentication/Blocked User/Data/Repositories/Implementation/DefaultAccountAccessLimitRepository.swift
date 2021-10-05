//
//  DefaultAccountAccessLimitRepository.swift
//  Mobile
//
//  Created by Giga Khizanishvili on 05.10.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

struct DefaultAccountAccessLimitRepository: AccountAccessLimitRepository {
	@Inject private var dataTransferService: DataTransferService
	@Inject private var userSession: UserSessionReadableServices
	@Inject private var languageStorage: LanguageStorage
	private var requestBuilder: HttpRequestBuilder { HttpRequestBuilderImpl.createInstance() }
	
	func execute(handler: (Result<AccountAccessLimitEntity, ABError>) -> Void) {
		guard let userId = userSession.userId else {
			handler(.failure(.init(type: .sessionNotFound)))
			return
		}
		
		let request = self.requestBuilder
			.set(host: "https://mobileapi.adjarabet.com/bonus/active?userId=\(userId)&language=\(languageStorage.currentLanguage.mobileApiLocalizableIdentifier)&domain=\("com")&page=\(1)")
			.set(method: HttpMethodGet())
			.build()
		
//		dataTransferService.performTask(expecting: AccountAccessLimitDTO.self,
//										request: request,
//										respondOnQueue: .main,
//										completion: handler)
	}
}
