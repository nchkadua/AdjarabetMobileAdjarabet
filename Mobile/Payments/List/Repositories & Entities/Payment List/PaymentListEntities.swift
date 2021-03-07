//
//  PaymentListEntities.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 3/7/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

struct PaymentListEntity {
    let elements: [ElementEntity]

    struct ElementEntity {
        var applePay: [String]?
        var segmentList: [String]?
        var segmentListEmoney: [String]?
        let method: PaymentMethodEntity
    }
}

struct PaymentMethodEntity {
    let methodType: String
    let flowId: String
    let iconUrl: String
    let downtimeId: String
    let channelId: String
}
