//
//  PaymentListEntities.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 3/7/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

public struct PaymentListEntity {
    let elements: [ElementEntity]

    struct ElementEntity {
        let applePay: [String]?
        let segmentList: [String]?
        let segmentListEmoney: [String]?
        let method: PaymentMethodEntity
    }
}

public struct PaymentMethodEntity {
    let methodType: String
    let flowId: String
    let iconUrl: String
    let downtimeId: String
    let channelId: String
}
