//
//  MobileAPIPrivacyPolicyDTO.swift
//  Mobile
//
//  Created by Nika Chkadua on 13.09.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

struct PrivacyPolicyDTO: DataTransferResponse {
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

    typealias Entity = PrivacyPolicyEntity

    static func entity(header: DataTransferResponseDefaultHeader, body: Body) -> Result<Entity, ABError>? {
        return .success(.init(en: body.html.en, ge: body.html.ge, ru: body.html.ru))
    }
}
