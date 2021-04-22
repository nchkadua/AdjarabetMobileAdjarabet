//
//  PaymentAccountEntity.swift
//  Mobile
//
//  Created by Giorgi Kratsashvili on 1/26/21.
//  Copyright © 2021 Adjarabet. All rights reserved.
//

import Foundation

// FIXME: Make accountVisual (and all other fields) required
public struct PaymentAccountEntity: MyCardable {
    public let id: Int64?
    public let status: Status?
    public let isVerified: Bool?
    public let providerId: String?
    public let providerName: String?
    public let providerServiceId: Int64?
    public let accountVisual: String?
    public let expiryDate: Date?
    public let dateCreated: Date?
    public let dateModified: Date?
}
