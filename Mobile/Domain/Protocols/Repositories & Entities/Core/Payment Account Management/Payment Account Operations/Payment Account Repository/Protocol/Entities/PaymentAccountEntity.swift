//
//  PaymentAccountEntity.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 1/26/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

struct PaymentAccountEntity: MyCardable {
    let id: Int64
    let accountVisual: String
    let providerName: String?
    let dateCreated: String?
}
