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
        let html: String

        enum CodingKeys: String, CodingKey {
            case html
        }
    }

    typealias Entity = PrivacyPolicyEntity

    static func entity(header: DataTransferResponseDefaultHeader, body: Body) -> Result<Entity, ABError>? {
        return .success(.init(html: body.html))
    }
}
