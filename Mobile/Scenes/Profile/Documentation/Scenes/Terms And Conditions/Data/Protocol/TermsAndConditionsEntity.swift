//
//  TermsAndConditionsEntity.swift
//  Mobile
//
//  Created by Giga Khizanishvili on 16.09.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

public struct TermsAndConditionsEntity {
	let list: [Category]
	
	public struct Category {
		let title: String
		let html: String
	}
}
