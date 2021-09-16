//
//  MobileApiTermsAndConditionsDTO.swift
//  Mobile
//
//  Created by Giga Khizanishvili on 16.09.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

struct TermsAndConditionsDTO: DataTransferResponse {
	struct Body: Codable {
		let html: PPHtml

		struct PPHtml: Codable {
			var en: String
			var ge: String
			var ru: String

			enum CodingKeys: String, CodingKey {
				case en
				case ge
				case ru
			}
		}

		enum CodingKeys: String, CodingKey {
			case html
		}
	}

	typealias Entity = TermsAndConditionsEntity

	static func entity(header: DataTransferResponseDefaultHeader, body: Body) -> Result<Entity, ABError>? {
		return .success(.init(en: body.html.en, ge: body.html.ge, ru: body.html.ru))
	}
}
