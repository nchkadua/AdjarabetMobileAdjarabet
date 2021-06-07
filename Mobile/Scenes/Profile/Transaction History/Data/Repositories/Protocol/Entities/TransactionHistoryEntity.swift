//
//  TransactionHistoryEntity.swift
//  Mobile
//
//  Created by Irakli Shelia on 11/30/20.
//  Copyright © 2020 Adjarabet. All rights reserved.
//

import Foundation

public struct TransactionHistoryEntity {
    public let totalAmount: Double
    public let date: Date
    public let feeAmount: Double
    public let providerName: String

    init?(totalAmount: Double?, date: Date?, feeAmount: Double?, providerName: String?) {
        guard let date = date, let providerName = providerName, let feeAmount = feeAmount, let totalAmount = totalAmount  else { return nil }
        self.totalAmount = totalAmount
        self.date = date
        self.feeAmount = feeAmount
        self.providerName = providerName
    }
}
