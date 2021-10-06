//
//  AccountAccessLimitEntity.swift
//  Mobile
//
//  Created by Giga Khizanishvili on 05.10.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

public struct AccountAccessLimitEntity {
	let limits: [AccountAccessLimitObject]

	public struct AccountAccessLimitObject {
		let limitType: Int 			// TODO change to int or enum
		let periodType: Int 			// TODO change to enum
		let periodStartDate: String 	// TODO change to date
		let periodEndDate: String 		// TODO change to date
		let limitSetDate: String 		// TODO change to date
		let dateModified: String		// TODO change to date
	}
}
