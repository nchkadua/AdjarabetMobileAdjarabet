//
//  TermsAndConditionsRepository.swift
//  Mobile
//
//  Created by Giga Khizanishvili on 16.09.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

protocol TermsAndConditionsRepository {
	typealias TermsAndConditionsHandler = (Result<TermsAndConditionsEntity, ABError>) -> Void
	func getUrl(handler: @escaping TermsAndConditionsHandler)
}
