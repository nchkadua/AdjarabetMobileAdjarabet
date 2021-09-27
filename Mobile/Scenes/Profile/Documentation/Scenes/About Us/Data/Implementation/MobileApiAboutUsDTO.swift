//
//  MobileApiAboutUsDTO.swift
//  Mobile
//
//  Created by Nika Chkadua on 27.09.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

struct MobileApiAboutUsDTO: DataTransferResponse {
    struct Body: Codable {
        let html: String

        enum CodingKeys: String, CodingKey {
            case html
        }
    }

    typealias Entity = AboutUsEntity

    static func entity(header: DataTransferResponseDefaultHeader, body: Body) -> Result<Entity, ABError>? {
        .success(.init(html: body.html))
    }
}
