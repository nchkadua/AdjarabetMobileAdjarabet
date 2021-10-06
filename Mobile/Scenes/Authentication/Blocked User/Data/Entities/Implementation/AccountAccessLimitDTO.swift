//
//  AccountAccessLimitDTO.swift
//  Mobile
//
//  Created by Giga Khizanishvili on 05.10.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

public struct AccountAccessLimitDTO: DataTransferResponse {
	struct Body: Codable {
		let statusCode: Int
		let accountAccessLimits: [AccountAccessLimitObject]?

		struct AccountAccessLimitObject: Codable {
			let limitType: Int
			let periodType: Int
			let periodStartDate: String
			let periodEndDate: String
			let limitSetDate: String
			let dateModified: String

			enum CodingKeys: String, CodingKey {
				case limitType = "LimitType"
				case periodType = "PeriodType"
				case periodStartDate = "PeriodStartDate"
				case periodEndDate = "PeriodEndDate"
				case limitSetDate = "LimitSetDate"
				case dateModified = "DateModified"
			}
		}

		enum CodingKeys: String, CodingKey {
			case statusCode = "StatusCode"
			case accountAccessLimits = "AccountAccessLimit"
		}
	}

	typealias Entity = AccountAccessLimitEntity

	static func entity(header: DataTransferResponseDefaultHeader, body: Body) -> Result<Entity, ABError>? {
		// TODO: add guard about status codes
		if let accountAccessLimits = body.accountAccessLimits {
			return .success(.init(limits: accountAccessLimits.map { limit in
				.init(
					limitType: limit.limitType,
					periodType: limit.periodType,
					periodStartDate: limit.periodStartDate,
					periodEndDate: limit.periodEndDate,
					limitSetDate: limit.limitSetDate,
					dateModified: limit.dateModified)
			}))
		} else {
			return .failure(.init(type: .notFound))
		}
	}
}
