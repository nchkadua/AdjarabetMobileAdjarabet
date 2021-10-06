//
//  AccountAccessLimitDTO.swift
//  Mobile
//
//  Created by Giga Khizanishvili on 05.10.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

public struct AccountAccessLimitDTO: CoreDataTransferResponse {
	struct Body: CoreStatusCodeable {
		let statusCode: Int
		let accountAccessLimit: AccountAccessLimitObject?

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
			case accountAccessLimit = "AccountAccessLimit"
		}
	}

	typealias Entity = AccountAccessLimitEntity

	static func entitySafely(header: Header, body: Body) -> Result<Entity, ABError>? {
		if let limit = body.accountAccessLimit {
			return .success(
				.init(limit: .init(limitType: limit.limitType,
								   periodType: limit.periodType,
								   periodStartDate: limit.periodStartDate,
								   periodEndDate: limit.periodEndDate,
								   limitSetDate: limit.limitSetDate,
								   dateModified: limit.dateModified))
			)
		} else {
			return .success(.init(limit: nil))
		}
	}
}
