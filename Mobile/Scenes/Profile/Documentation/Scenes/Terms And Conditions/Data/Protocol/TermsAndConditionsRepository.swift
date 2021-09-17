//
//  TermsAndConditionsRepository.swift
//  Mobile
//
//  Created by Giga Khizanishvili on 16.09.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

protocol TermsAndConditionsRepository {
	typealias Handler = (Result<TermsAndConditionsEntity, ABError>) -> Void
	
	func execute(handler: @escaping Handler, language: Language)
}
