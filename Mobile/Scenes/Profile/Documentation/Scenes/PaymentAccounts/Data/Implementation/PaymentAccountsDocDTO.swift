//
//  PaymentAccountsDocDTO.swift
//  Mobile
//
//  Created by Nika Chkadua on 06.10.21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

struct PaymentAccountsDocDTO: DataTransferResponse {
    struct Body: Codable {
        let html: String

        enum CodingKeys: String, CodingKey {
            case html
        }
    }

    typealias Entity = PaymentAccountsDocEntity

    static func entity(header: DataTransferResponseDefaultHeader, body: Body) -> Result<Entity, ABError>? {
        .success(.init(html: body.html))
    }
}
