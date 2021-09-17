//
//  TermsAndConditionsUseCase.swift
//  Mobile
//
//  Created by Giga Khizanishvili on 17.09.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

protocol TermsAndConditionsUseCase {
	func process(handler: @escaping TermsAndConditionsRepository.Handler)
}
