//
//  AccountAccessLimitEntity.swift
//  Mobile
//
//  Created by Giga Khizanishvili on 05.10.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

public struct AccountAccessLimitEntity {
	let limit: AccountAccessLimitObject?

	public struct AccountAccessLimitObject {
		let limitType: SelfRestrictionType
		let periodType: Int 			// TODO change to enum
		let periodStartDate: String 	// TODO change to date
		let periodEndDate: String 		// TODO change to date
		let limitSetDate: String 		// TODO change to date
		let dateModified: String		// TODO change to date

		public init(limitType: Int = SelfRestrictionType.selfSuspension.rawValue,
					periodType: Int = 1,
					periodStartDate: String = "",
					periodEndDate: String = "",
					limitSetDate: String = "",
					dateModified: String = ""
		) {
			if let limitType = SelfRestrictionType(rawValue: limitType) {
				self.limitType = limitType
			} else {
				self.limitType = .selfSuspension
			}
			self.periodType = periodType
			self.periodStartDate = periodStartDate
			self.periodEndDate = periodEndDate
			self.limitSetDate = limitSetDate
			self.dateModified = dateModified
		}
	}
}
