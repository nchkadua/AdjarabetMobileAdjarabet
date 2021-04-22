//
//  PaymentAccountEntity.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 1/26/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

// FIXME: Make accountVisual (and all other fields) required
struct PaymentAccountEntity: MyCardable {
    let id: Int64
    let accountVisual: String
    let providerName: String?
    let dateCreated: String?
}
