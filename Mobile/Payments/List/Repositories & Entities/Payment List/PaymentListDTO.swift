//
//  PaymentListDTO.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 3/7/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

struct PaymentListDTO: DataTransferResponse {
    struct Body: Codable {
        let itemClass: String?
    }

    typealias Entity = PaymentListEntity

    static func entity(header: DataTransferResponseDefaultHeader, body: Body) -> Entity? {
        .init(temp: body.itemClass ?? "nil")
    }
}
