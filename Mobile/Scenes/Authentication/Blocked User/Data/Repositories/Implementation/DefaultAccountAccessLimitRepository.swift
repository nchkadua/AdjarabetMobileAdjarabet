//
//  DefaultAccountAccessLimitRepository.swift
//  Mobile
//
//  Created by Giga Khizanishvili on 05.10.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

struct DefaultAccountAccessLimitRepository: CoreApiRepository { }
//	@Inject private var dataTransferService: DataTransferService
//	@Inject private var userSession: UserSessionReadableServices
//	@Inject private var languageStorage: LanguageStorage
//	private var requestBuilder: HttpRequestBuilder { HttpRequestBuilderImpl.createInstance() }

extension DefaultAccountAccessLimitRepository: AccountAccessLimitRepository {
	func execute(limitType: SelfRestrictionType, handler: @escaping (Result<AccountAccessLimitEntity, ABError>) -> Void) {
//		guard let userId = userSession.userId else {
//			handler(.failure(.initJ(type: .sessionNotFound)))
//			return
//		}

//		let request = self.requestBuilder
//			.set(host: "https://mobileapi.adjarabet.com/bonus/active?userId=\(userId)&language=\(languageStorage.currentLanguage.mobileApiLocalizableIdentifier)&domain=\("com")&page=\(1)")
//			.set(method: HttpMethodGet())
//			.build()
//
//		dataTransferService.performTask(
//			expecting: AccountAccessLimitDTO.self,
//			request: request,
//			respondOnQueue: .main,
//			completion: handler)

		performTask(expecting: AccountAccessLimitDTO.self, completion: handler) { requestBuilder in
			requestBuilder
				.setBody(key: .req, value: "getAccountAccessLimit")
				.setBody(key: .limitType, value: "\(limitType.rawValue)")
		}
	}
}
