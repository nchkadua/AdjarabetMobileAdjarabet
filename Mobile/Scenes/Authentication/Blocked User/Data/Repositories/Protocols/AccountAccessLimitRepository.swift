//
//  AccountAccessLimitRepository.swift
//  Mobile
//
//  Created by Giga Khizanishvili on 05.10.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

protocol AccountAccessLimitRepository {
	typealias Handler = (Result<AccountAccessLimitEntity, ABError>) -> Void
	
	func execute(handler: Handler)
}
