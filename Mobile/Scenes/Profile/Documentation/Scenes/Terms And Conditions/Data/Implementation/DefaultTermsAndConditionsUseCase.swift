//
//  DefaultTermsAndConditionsUseCase.swift
//  Mobile
//
//  Created by Giga Khizanishvili on 17.09.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

class DefaultTermsAndConditionsUseCase: TermsAndConditionsUseCase {
	@Inject (from: .repositories) private var repo: TermsAndConditionsRepository
	@Inject private var languageStorage: LanguageStorage

	public func process(handler: @escaping TermsAndConditionsRepository.Handler) {
		repo.execute(handler: handler, language: languageStorage.currentLanguage)
	}
}
