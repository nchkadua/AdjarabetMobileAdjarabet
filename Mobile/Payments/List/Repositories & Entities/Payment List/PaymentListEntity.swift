//
//  PaymentListEntity.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 3/7/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

struct PaymentListEntity {
    let methods: [PaymentMethodEntity]
}

struct PaymentMethodEntity {
    var applePay: [String]?
    var segmentList: [String]?
    var segmentListEmoney: [String]?
}
