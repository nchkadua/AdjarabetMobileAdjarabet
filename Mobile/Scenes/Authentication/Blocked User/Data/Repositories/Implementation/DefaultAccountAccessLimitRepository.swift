//
//  DefaultAccountAccessLimitRepository.swift
//  Mobile
//
//  Created by Giga Khizanishvili on 05.10.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

struct DefaultAccountAccessLimitRepository: CoreApiRepository { }

extension DefaultAccountAccessLimitRepository: AccountAccessLimitRepository {
	func execute(limitType: SelfRestrictionType, handler: @escaping (Result<AccountAccessLimitEntity, ABError>) -> Void) {
		performTask(expecting: AccountAccessLimitDTO.self, completion: handler) { requestBuilder in
			requestBuilder
				.setBody(key: .req, value: "getAccountAccessLimit")
				.setBody(key: .limitType, value: "\(limitType.rawValue)")
		}
	}
}
