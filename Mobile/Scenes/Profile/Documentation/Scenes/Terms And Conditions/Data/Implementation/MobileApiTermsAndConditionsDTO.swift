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
		let list: [Category]

		struct Category: Codable {
			let title: String
			let html: String

			enum CodingKeys: String, CodingKey {
				case title
				case html
			}
		}

		enum CodingKeys: String, CodingKey {
			case list
		}
	}

	typealias Entity = TermsAndConditionsEntity

	static func entity(header: DataTransferResponseDefaultHeader, body: Body) -> Result<Entity, ABError>? {
		let categories = body.list.map({ Entity.Category(title: $0.title, html: $0.html) })
		return .success(Entity(list: categories))
	}
}
